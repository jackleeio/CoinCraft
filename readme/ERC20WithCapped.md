# Capped Token

Twitter: [Jack Lee](https://x.com/jackleeio)｜[Conflux DAO](https://x.com/ConfluxDAO)

Community: [JackLee.io](https://jacklee.io/) ｜[Conflux Forum](https://forum.conflux.fun/)

All code and tutorials are open source on GitHub: https://github.com/jackleeio/CoinCraft

---

A capped token is a type of mintable token that has a maximum minting limit set. When the minting reaches this cap, an exception will be thrown.

## Contract

[Capped Token: ERC20WithCapped.sol](../src/ERC20/ERC20WithCapped.sol)

## Tests

## Method Calls

## Deployment

To deploy the ERC20WithCapped token using Foundry, follow these steps:

1. Make sure you have Foundry installed. If not, refer to the [Foundry Installation Guide](https://book.getfoundry.sh/getting-started/installation).

2. Create a `.env` file in the project root directory and add the following content:

   ```
   PRIVATE_KEY=your_private_key
   RPC_URL=your_target_network_rpc_url
   ```

3. Create a deployment script `script/DeployERC20WithCapped.s.sol`:

   ```solidity:script/DeployERC20WithCapped.s.sol
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.24;

   import "forge-std/Script.sol";
   import "../src/ERC20/ERC20WithCapped.sol";

   contract DeployERC20WithCapped is Script {
       function run() external {
           uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
           vm.startBroadcast(deployerPrivateKey);

           ERC20WithCapped token = new ERC20WithCapped(
               "Capped Token",
               "CAP",
               18,
               1000000 * 10**18 // Set cap to 1,000,000 tokens
           );

           vm.stopBroadcast();
       }
   }
   ```

4. Run the following command to deploy:

   ```
   forge script script/DeployERC20WithCapped.s.sol:DeployERC20WithCapped --rpc-url $RPC_URL --broadcast --verify
   ```

5. After deployment, you will see the deployed contract address in the console output. Save this address for future use.

Note: Before deploying, ensure your account has enough native tokens (e.g., ETH, CFX) to cover gas fees.
