// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "src/ERC20/ERC20WithPausable.sol";

contract DeployERC20WithPausable is Script {
    function run() external {
        // uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        // vm.startBroadcast(deployerPrivateKey);
        vm.startBroadcast();

        ERC20WithPausable token = new ERC20WithPausable(
            "Pausable Token",  // Token name
            "PAUSE",           // Token symbol
            1000000 * 10**18   // Total supply of 1,000,000 tokens
        );

        vm.stopBroadcast();

        console.log("ERC20WithPausable deployed at:", address(token));
    }
}