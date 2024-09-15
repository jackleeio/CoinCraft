// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../../src/ERC20/ERC20WithTimelock.sol";

contract DeployERC20WithTimelock is Script {
    function run() external {
        vm.startBroadcast();

        ERC20WithTimelock token = new ERC20WithTimelock(
            "Timelock Token",
            "LOCK",
            1000000 * 10**18, // Initial supply
            msg.sender,       // Initial owner
            365 days          // Lock duration of 1 year
        );

        vm.stopBroadcast();

        console.log("ERC20WithTimelock deployed at:", address(token));
    }
}