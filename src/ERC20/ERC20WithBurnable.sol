// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// Burnable token:
// A burnable token allows the holder to destroy their tokens or let someone else do it with approval.
contract ERC20WithBurnable is ERC20, ERC20Burnable {
    // Constructor for the burnable ERC20 token
    // Initializes the token with a name, symbol, decimals, and total supply
    constructor(
        string memory name,      // The name of the token
        string memory symbol,    // The symbol of the token
        uint8 decimals,          // The number of decimals for the token
        uint256 totalSupply      // The total supply of the token
    ) ERC20(name, symbol) {
        _mint(msg.sender, totalSupply * (10**uint256(decimals))); // Mint the total supply to the contract deployer
    }
}
