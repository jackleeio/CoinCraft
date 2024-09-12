// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Importing the ERC20 standard implementation
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// Importing the ERC20Capped extension to add a cap on the total supply
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

// ERC20WithCapped contract that extends ERC20 and ERC20Capped
contract ERC20WithCapped is ERC20, ERC20Capped {
    // Constructor to initialize the token with name, symbol, decimals, initial supply, and cap
    constructor(
        string memory name, // The name of the token
        string memory symbol, // The symbol of the token
        uint8 decimals, // The number of decimals for the token
        uint256 initialSupply, // The initial supply of the token
        uint256 _cap // The maximum cap for the token supply
    ) ERC20(name, symbol) ERC20Capped(_cap) {
        // Minting the initial supply to the contract deployer
        _mint(msg.sender, initialSupply * (10 ** decimals));
    }

    // Overriding the _update function to include cap validation
    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Capped) {
        // Calling the _update function from ERC20Capped
        ERC20Capped._update(from, to, value);
    }
}