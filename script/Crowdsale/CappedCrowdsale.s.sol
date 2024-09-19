// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../../src/Crowsale/CappedCrowdsale.sol";
import "../../src/ERC20/ERC20FixedSupply.sol";

contract DeployCappedCrowdsale is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy a fixed supply ERC20 token for the crowdsale
        uint256 initialSupply = 10000000 * 10 ** 18; // 10,000,000 tokens
        ERC20FixedSupply token = new ERC20FixedSupply(
            "CraftCoin",
            "CRAFT",
            initialSupply
        );

        // Set crowdsale parameters
        uint256 rate = 100; // 1 ETH = 100 tokens
        address payable wallet = payable(msg.sender);
        uint256 openingTime = block.timestamp + 1 days; // Crowdsale starts in 1 day
        uint256 closingTime = openingTime + 30 days; // Crowdsale lasts for 30 days
        uint256 cap = 1000000 * 10 ** 18; // Set cap to 1,000,000 tokens

        CappedCrowdsale crowdsale = new CappedCrowdsale(
            rate,
            wallet,
            IERC20(address(token)),
            openingTime,
            closingTime,
            cap
        );

        // Transfer some tokens to the crowdsale contract
        uint256 crowdsaleAllocation = 1000000 * 10 ** 18; // 1,000,000 tokens
        token.transfer(address(crowdsale), crowdsaleAllocation);

        vm.stopBroadcast();

        console.log("ERC20FixedSupply Token deployed at:", address(token));
        console.log("CappedCrowdsale deployed at:", address(crowdsale));
    }
}