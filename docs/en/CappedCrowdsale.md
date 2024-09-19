# Capped Crowdsale Contract

Twitter: [Jack Lee](https://x.com/jackleeio)｜[Conflux DAO](https://x.com/ConfluxDAO)

Community: [JackLee.io](https://jacklee.io/) ｜[Conflux Forum](https://forum.conflux.fun/)

All code and tutorials are open-sourced on GitHub: https://github.com/jackleeio/TokenCraft

---

# Overview

The `CappedCrowdsale` contract allows project teams to raise funds by selling ERC20 tokens with a cap on the total amount of tokens sold. This contract ensures that the token sale does not exceed the specified cap.

## Contract

[CappedCrowdsale Contract: CappedCrowdsale.sol](../../src/Crowdsale/CappedCrowdsale.sol)

## Testing

```
forge test --match-contract CappedCrowdsaleTest -vvv
```
Tests should cover the following scenarios:

1. Initial token allocation
2. Validation of crowdsale start and end times
3. Token purchase behavior
4. Withdrawal of unsold tokens

## Method Calls

The `CappedCrowdsale` contract inherits from `Ownable`. The main method calls are:

1. `buyTokens()`: Allows users to purchase tokens.
2. `withdrawTokens()`: Allows the owner to withdraw unsold tokens.
3. `hasCrowdsaleStarted()`: Checks if the crowdsale has started.
4. `hasCrowdsaleEnded()`: Checks if the crowdsale has ended.

## Deployment Script

The `CappedCrowdsaleDeploy.s.sol` script is used to deploy the token contract and the crowdsale contract. It sets the following parameters:

- Rate: 1 ETH = 100 tokens
- Crowdsale allocation: Set as needed
- Crowdsale start time: 1 day after deployment
- Crowdsale duration: 30 days
- Crowdsale cap: Set to 1,000,000 tokens

To deploy the `CappedCrowdsale`, you can use the following script:

```
forge script script/Crowdsale/CappedCrowdsaleDeploy.s.sol:CappedCrowdsaleDeploy --rpc-url $RPC_URL --broadcast --verify
```

Note: Before deploying, make sure your account has enough native tokens (such as ETH, CFX) to pay for gas fees.

