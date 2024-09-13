// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Importing the ERC20 standard contract
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// Importing the ERC20Pausable extension for pausable token functionality
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
// Importing the Ownable contract for pausable token functionality
import "@openzeppelin/contracts/access/Ownable.sol";

// ERC20WithPausable contract that extends ERC20, ERC20Pausable, and Ownable
contract ERC20WithPausable is ERC20, ERC20Pausable, Ownable {
    // Constructor to initialize the token with name, symbol, and total supply
    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply
    ) ERC20(name, symbol) Ownable(msg.sender) {
        // Minting the total supply to the contract deployer
        _mint(msg.sender, totalSupply * 10 ** decimals());
    }

    // Overriding the _update function to include pausable functionality
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20, ERC20Pausable) {
        // Calling the _update function from ERC20Pausable
        ERC20Pausable._update(from, to, value);
    }

    /**
     * @dev Pauses the contract, preventing token transfers.
     * Only callable by the owner.
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev Unpauses the contract, allowing token transfers.
     * Only callable by the owner.
     */
    function unpause() external onlyOwner {
        _unpause();
    }
}
