# 时间锁定代币

Twitter: [Jack Lee](https://x.com/jackleeio)｜[Conflux DAO](https://x.com/ConfluxDAO)

社区: [JackLee.io](https://jacklee.io/) ｜[Conflux Forum](https://forum.conflux.fun/)

所有代码和教程都在 GitHub 上开源: https://github.com/jackleeio/CoinCraft

---

时间锁定代币是一种特殊的 ERC20 代币，允许代币在一定时期内被锁定，防止转账。这种机制通常用于团队代币、投资者代币或奖励计划，以确保代币只能在特定时间后使用。

## 合约

[时间锁定代币: ERC20WithTimelock.sol](../src/ERC20/ERC20WithTimelock.sol)

## 测试

```
forge test --match-contract ERC20WithTimelockTest -vvv
```

测试应涵盖以下场景:
1. 初始代币分配
2. 锁定期间的转账限制
3. 解锁后的转账行为
4. 查询锁定余额和解锁时间

## 方法调用

ERC20WithTimelock 合约继承自 ERC20 和 Ownable。以下是主要的方法调用:

1. `unlockTokens()`: 在锁定期结束后解锁代币。
2. `getLockedBalance(address account)`: 获取指定地址的