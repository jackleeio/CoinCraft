# 众筹合约

Twitter: [Jack Lee](https://x.com/jackleeio)｜[Conflux DAO](https://x.com/ConfluxDAO)

社区: [JackLee.io](https://jacklee.io/) ｜[Conflux Forum](https://forum.conflux.fun/)

所有代码和教程都在 GitHub 上开源: https://github.com/jackleeio/CoinCraft

---

# Start of Selection
众筹合约允许项目方通过销售ERC20代币来筹集资金。该合约支持固定供应量的代币，并提供灵活的众筹参数设置。


## 合约

[众筹合约: Crowdsale.sol](../../src/ERC20/Crowdsale.sol)

## 测试

```
forge test --match-contract SimpleCrowdsaleTest -vvv
```

测试应涵盖以下场景:
1. 初始代币分配
2. 众筹开始和结束时间的验证
3. 购买代币的行为
4. 提取未售出代币的行为

## 方法调用

SimpleCrowdsale 合约继承自 Ownable。以下是主要的方法调用:

1. `buyTokens()`: 允许用户购买代币。
2. `withdrawTokens()`: 项目方提取未售出代币。
3. `hasCrowdsaleStarted()`: 检查众筹是否已开始。
4. `hasCrowdsaleEnded()`: 检查众筹是否已结束。

## 部署脚本

`Crowdsale.s.sol`脚本用于部署代币合约和众筹合约。它设置了以下参数：

- 初始代币供应量：10,000,000 CRAFT
- 众筹分配量：1,000,000 CRAFT
- 兑换率：1 ETH = 100 CRAFT
- 众筹开始时间：部署后1天
- 众筹持续时间：30天