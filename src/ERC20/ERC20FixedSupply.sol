// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Fixed supply token
// A fixed supply token is a basic ERC20 token that includes the token name, symbol, decimals, and total supply.
contract ERC20FixedSupply is ERC20 {
    constructor(
        string memory name, // Token name
        string memory symbol, // Token symbol
        uint8 decimals, // Decimals
        uint256 totalSupply // Total supply
    ) ERC20(name, symbol) {
        _mint(msg.sender, totalSupply * (10**uint256(decimals)));
    }
}