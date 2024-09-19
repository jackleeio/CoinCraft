// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../../src/Crowsale/Crowdsale.sol";
import "../../src/ERC20/ERC20FixedSupply.sol";

contract DeployERC20Crowdsale is Script {
    function run() external {
        vm.startBroadcast();

        // 部署一个固定供应量的ERC20代币作为众筹的代币
        uint256 initialSupply = 10000000 * 10 ** 18; // 10,000,000 tokens
        ERC20FixedSupply token = new ERC20FixedSupply(
            "CraftCoin",
            "CRAFT",
            initialSupply
        );

        // 设置众筹参数
        uint256 rate = 100; // 1 ETH = 100 tokens
        address payable wallet = payable(msg.sender);
        uint256 openingTime = block.timestamp + 1 days; // 众筹在1天后开始
        uint256 closingTime = openingTime + 30 days; // 众筹持续30天

        SimpleCrowdsale crowdsale = new SimpleCrowdsale(
            rate,
            wallet,
            IERC20(address(token)),
            openingTime,
            closingTime
        );

        // 将一些代币转移到众筹合约中
        uint256 crowdsaleAllocation = 1000000 * 10 ** 18; // 1,000,000 tokens
        token.transfer(address(crowdsale), crowdsaleAllocation);

        vm.stopBroadcast();

        console.log("ERC20FixedSupply Token deployed at:", address(token));
        console.log("SimpleCrowdsale deployed at:", address(crowdsale));
    }
}
