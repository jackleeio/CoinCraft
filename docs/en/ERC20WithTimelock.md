# Timelock Token

Twitter: [Jack Lee](https://x.com/jackleeio)｜[Conflux DAO](https://x.com/ConfluxDAO)

Community: [JackLee.io](https://jacklee.io/) ｜[Conflux Forum](https://forum.conflux.fun/)

All code and tutorials are open source on GitHub: https://github.com/jackleeio/CoinCraft

---

Timelock tokens are a special type of ERC20 token that allows tokens to be locked for a certain period, preventing transfers. This mechanism is commonly used for team tokens, investor tokens, or reward programs to ensure that tokens can only be used after a specific time.

## Contract

[Timelock Token: ERC20WithTimelock.sol](../src/ERC20/ERC20WithTimelock.sol)

## Testing

```
forge test --match-contract ERC20WithTimelockTest -vvv
```

The tests should cover the following scenarios:
1. Initial token distribution
2. Transfer restrictions during the lock period
3. Transfer behavior after unlocking
4. Querying locked balances and unlock times

## Method Calls

The ERC20WithTimelock contract inherits from ERC20 and Ownable. Here are the main method calls:

1. `unlockTokens()`: Unlocks tokens after the lock period ends.
2. `getLockedBalance(address account)`: Gets the locked balance for a specified address.
3. `getLockEndTime(address account)`: Gets the lock end time for a specified address.
4. `getTotalLockedTokens()`: Gets the total amount of locked tokens.
5. `transfer(address to, uint256 amount)`: Transfers tokens (includes balance check).
6. `transferFrom(address from, address to, uint256 amount)`: Transfers tokens from one address to another (includes balance check).
7. `balanceOf(address account)`: Returns the token balance of the specified address (including locked tokens).

## Deployment

To deploy the ERC20WithTimelock token using Foundry, follow these steps:

1. Make sure Foundry is installed. If not, refer to the [Foundry Installation Guide](https://book.getfoundry.sh/getting-started/installation).

2. Create a `.env` file in the project root directory and add the following content:

   ```
   PRIVATE_KEY=your_private_key
   RPC_URL=your_target_network_rpc_url
   ```

3. Run the following command to deploy:

   ```
   forge script script/ERC20/ERC20WithTimelock.s.sol:DeployERC20WithTimelock --rpc-url $RPC_URL --broadcast --verify
   ```

4. After deployment, you will see the deployed contract address in the console output. Save this address for future use.

Note: Before deploying, make sure your account has enough native tokens (such as ETH, CFX) to pay for gas fees.