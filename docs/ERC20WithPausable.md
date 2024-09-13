# Pausable Token

Twitter: [Jack Lee](https://x.com/jackleeio)｜[Conflux DAO](https://x.com/ConfluxDAO)

Community: [JackLee.io](https://jacklee.io/) ｜[Conflux Forum](https://forum.conflux.fun/)

All code and tutorials are open source on GitHub: https://github.com/jackleeio/CoinCraft

---

A pausable token is a type of ERC20 token that can be paused and unpaused by the contract owner. When paused, all token transfers are suspended, which can be useful in emergency situations or during maintenance periods.

## Contract

[Pausable Token: ERC20WithPausable.sol](../src/ERC20/ERC20WithPausable.sol)

## Tests

To run the tests for the ERC20WithPausable contract, use the following command:

```
forge test --match-contract test/ERC20WithPausable.t.sol -vvv （TODO）
```

The tests should cover the following scenarios:
1. Initial token distribution
2. Pausing and unpausing the contract
3. Transfer behavior when paused and unpaused
4. Access control for pause and unpause functions

## Method Calls

The ERC20WithPausable contract inherits from both ERC20 and ERC20Pausable. Here are the main method calls:

1. `pause()`: Pauses the contract, preventing transfers.
2. `unpause()`: Unpauses the contract, allowing transfers.
3. `transfer(address to, uint256 amount)`: Transfers tokens to a specified address.
4. `transferFrom(address from, address to, uint256 amount)`: Transfers tokens from one address to another.
5. `balanceOf(address account)`: Returns the token balance of the specified address.
6. `approve(address spender, uint256 amount)`: Approves the specified address to spend a certain amount of tokens.
7. `allowance(address owner, address spender)`: Returns the remaining number of tokens that the spender is allowed to spend on behalf of the owner.

## Deployment

To deploy the ERC20WithPausable token using Foundry, follow these steps:

1. Make sure you have Foundry installed. If not, refer to the [Foundry Installation Guide](https://book.getfoundry.sh/getting-started/installation).

2. Create a `.env` file in the project root directory and add the following content:

   ```
   PRIVATE_KEY=your_private_key
   RPC_URL=your_target_network_rpc_url
   ```

3. Create a deployment script `script/ERC20WithPausable.s.sol`:

   ```solidity:script/DeployERC20WithPausable.s.sol
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.24;

   import "forge-std/Script.sol";
   import "../src/ERC20/ERC20WithPausable.sol";

   contract DeployERC20WithPausable is Script {
       function run() external {
           uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
           vm.startBroadcast(deployerPrivateKey);

           ERC20WithPausable token = new ERC20WithPausable(
               "Pausable Token",
               "PAUSE",
               1000000 * 10**18 // Total supply of 1,000,000 tokens
           );

           vm.stopBroadcast();
       }
   }
   ```

4. Run the following command to deploy:

   ```
   forge script script/ERC20/ERC20WithPausable.s.sol:DeployERC20WithPausable --rpc-url $RPC_URL --broadcast --verify
   ```

5. After deployment, you will see the deployed contract address in the console output. Save this address for future use.

Note: Before deploying, ensure your account has enough native tokens (e.g., ETH, CFX) to cover gas fees.
