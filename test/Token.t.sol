// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

contract TokenTest is Test {
    Token token;

    address treasury;
    address alice;
    address bob;

    function setUp() public {
        treasury = makeAddr("treasury");
        alice = makeAddr("alice");
        bob = makeAddr("bob");

        token = new Token(treasury);
    }

    function testInitialSupply() public view {
        assertEq(token.totalSupply(), 1_000_000e18);
    }

    function testTokenNameAndSymbol() public view {
        assertEq(token.name(), "Nova");
        assertEq(token.symbol(), "NV");
    }

    function testOwnerCanMint() public {
        uint256 amount = 100e18;

        token.mint(alice, amount);

        assertEq(token.balanceOf(alice), amount);
    }

    function testOnlyOwnerCanMint() public {
        vm.prank(alice);

        vm.expectRevert();

        token.mint(alice, 100e18);
    }

    function testTransferWithTax() public {
        token.transfer(alice, 100e18);

        // 2% tax
        assertEq(token.balanceOf(treasury), 2e18);
        assertEq(token.balanceOf(alice), 98e18);
    }

    function testBlacklistBlocksTransfer() public {
        token.transfer(alice, 100e18);

        token.setBlacklist(alice, true);

        vm.prank(alice);

        vm.expectRevert("Blacklisted");

        token.transfer(bob, 10e18);
    }

    function testOwnerCanChangeTax() public {
        token.setTax(5);

        assertEq(token.tax(), 5);
    }

    function testOnlyOwnerCanChangeTax() public {
        vm.prank(alice);

        vm.expectRevert();

        token.setTax(5);
    }

    function testStake() public {
        token.stake(100e18);

        assertEq(token.staked(address(this)), 100e18);
    }

    function testUnstake() public {
        token.stake(100e18);

        token.unstake(50e18);

        assertEq(token.staked(address(this)), 50e18);
    }

    function testCannotUnstakeMoreThanStaked() public {
        vm.expectRevert("Not enough staked");

        token.unstake(100e18);
    }
}
