// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC1363} from "@openzeppelin/contracts/token/ERC20/extensions/ERC1363.sol";

contract Token is ERC20, ERC20Pausable, ERC20Permit, Ownable, ERC1363 {
    // Tax percent
    uint256 public tax = 2;

    // Treasury address
    address public treasury;

    // Blacklisted users
    mapping(address => bool) public blacklisted;

    // Staked balances
    mapping(address => uint256) public staked;

    constructor(address _treasury) ERC20("Nova", "NV") Ownable(msg.sender) ERC20Permit("Nova") {
        treasury = _treasury;
        require(_treasury != address(0), "Invalid treasury");
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }

    // Mint tokens
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // Set blacklist status
    function setBlacklist(address user, bool value) external onlyOwner {
        blacklisted[user] = value;
    }

    // Transfer logic with tax and checks
    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Pausable) whenNotPaused {
        require(!blacklisted[from] && !blacklisted[to], "Blacklisted");

        if (from == address(0) || to == address(0)) {
            super._update(from, to, value);
            return;
        }

        uint256 fee = (value * tax) / 100;
        uint256 sendAmount = value - fee;

        super._update(from, treasury, fee);
        super._update(from, to, sendAmount);
    }

    // Stake tokens
    function stake(uint256 amount) external {
        _transfer(msg.sender, address(this), amount);
        staked[msg.sender] += amount;
    }

    // Unstake tokens
    function unstake(uint256 amount) external {
        require(staked[msg.sender] >= amount, "Not enough staked");

        staked[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount);
    }

    //setting tax
    function setTax(uint256 newTax) external onlyOwner {
        require(newTax <= 10);
        tax = newTax;
    }
}
