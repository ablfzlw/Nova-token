// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";
import {console2} from "forge-std/console2.sol";

/// @title Token Deployment Script
/// @notice Deploys the Nova Token contract and logs deployment details
contract DeployToken is Script {
    
    address public treasuryAddress;

    function setUp() public {
        // Load treasury address from environment variable; defaults to deployer address if empty
        treasuryAddress = vm.envOr("TREASURY_ADDRESS", msg.sender);
    }

    function run() external {
        // Retrieve the deployer private key from environment variables
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        console2.log("================================================");
        console2.log("Initializing Nova Token Deployment on Amoy...");
        console2.log("Deployer Address:", vm.addr(deployerPrivateKey));
        console2.log("Treasury Address:", treasuryAddress);
        console2.log("================================================");

        // Start broadcasting transactions to the network
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the token contract passing the treasury address to the constructor
        Token token = new Token(treasuryAddress);

        // Stop broadcasting transactions
        vm.stopBroadcast();

        console2.log("================================================");
        console2.log("Nova Token successfully deployed!");
        console2.log("Contract Address:", address(token));
        console2.log("Token Name:", token.name());
        console2.log("Token Symbol:", token.symbol());
        console2.log("Initial Supply:", token.totalSupply());
        console2.log("================================================");
    }
}