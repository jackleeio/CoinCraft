# Crowdsale Contract

Twitter: [Jack Lee](https://x.com/jackleeio)｜[Conflux DAO](https://x.com/ConfluxDAO)

Community: [JackLee.io](https://jacklee.io/) ｜[Conflux Forum](https://forum.conflux.fun/)

All code and tutorials are open source on GitHub: https://github.com/jackleeio/TokenCraft

---

The Crowdsale contract allows project teams to raise funds by selling ERC20 tokens. This contract supports fixed supply tokens and provides flexible settings for crowdsale parameters.

## Contracts

[Crowdsale Contract: Crowdsale.sol](../../src/ERC20/Crowdsale.sol)

## Testing

```
forge test --match-contract SimpleCrowdsaleTest -vvv
```

Tests should cover the following scenarios:
1. Initial token allocation
2. Validation of crowdsale start and end times
3. Token purchase behavior
4. Withdrawal of unsold tokens

## Method Calls

The SimpleCrowdsale contract inherits from Ownable. Here are the main method calls:

1. `buyTokens()`: Allows users to purchase tokens.
2. `withdrawTokens()`: Allows the project team to withdraw unsold tokens.
3. `hasCrowdsaleStarted()`: Checks if the crowdsale has started.
4. `hasCrowdsaleEnded()`: Checks if the crowdsale has ended.

## Deployment Script

The `ERC20Crowdsale.s.sol` script is used to deploy both the token and crowdsale contracts. It sets the following parameters:

- Initial token supply: 10,000,000 CRAFT
- Crowdsale allocation: 1,000,000 CRAFT
- Exchange rate: 1 ETH = 100 CRAFT
- Crowdsale start time: 1 day after deployment
- Crowdsale duration: 30 days