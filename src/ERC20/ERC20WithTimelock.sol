// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Importing the ERC20 token standard from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// Importing the Ownable contract from OpenZeppelin
import "@openzeppelin/contracts/access/Ownable.sol";

// ERC20WithTimelock contract that extends ERC20 and Ownable
contract ERC20WithTimelock is ERC20, Ownable {
    // Mapping to store locked balances for each address
    mapping(address => uint256) private _lockedBalances;
    // Mapping to store the end time of the lock for each address
    mapping(address => uint256) private _lockEndTimes;
    // Total locked tokens
    uint256 private _totalLocked;

    // Event emitted when tokens are locked
    event TokensLocked(address indexed account, uint256 amount, uint256 unlockTime);
    // Event emitted when tokens are unlocked
    event TokensUnlocked(address indexed account, uint256 amount);

    // Constructor to initialize the token with name, symbol, initial supply, owner, and lock duration
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address initialOwner,
        uint256 lockDuration
    ) ERC20(name, symbol) Ownable(initialOwner) {
        // Mint and lock tokens for the initial owner
        _mintAndLock(initialOwner, initialSupply, lockDuration);
    }

    // Private function to mint tokens and lock them for a specified duration
    function _mintAndLock(address account, uint256 amount, uint256 lockDuration) private {
        _mint(address(this), amount); // Mint tokens to the contract itself
        _lockedBalances[account] = amount; // Set the locked balance for the account
        _lockEndTimes[account] = block.timestamp + lockDuration; // Set the lock end time
        _totalLocked += amount; // Update the total locked tokens
        emit TokensLocked(account, amount, _lockEndTimes[account]); // Emit the TokensLocked event
    }

    // Function to unlock tokens after the lock duration has passed
    function unlockTokens() public {
        require(_lockEndTimes[_msgSender()] <= block.timestamp, "Tokens are still locked"); // Check if tokens are still locked
        require(_lockedBalances[_msgSender()] > 0, "No locked tokens"); // Check if there are locked tokens

        uint256 amountToUnlock = _lockedBalances[_msgSender()]; // Get the amount to unlock
        _lockedBalances[_msgSender()] = 0; // Reset the locked balance
        _totalLocked -= amountToUnlock; // Update the total locked tokens
        _transfer(address(this), _msgSender(), amountToUnlock); // Transfer unlocked tokens to the sender

        emit TokensUnlocked(_msgSender(), amountToUnlock); // Emit the TokensUnlocked event
    }

    // Function to get the locked balance of an account
    function getLockedBalance(address account) public view returns (uint256) {
        return _lockedBalances[account]; // Return the locked balance
    }

    // Function to get the lock end time of an account
    function getLockEndTime(address account) public view returns (uint256) {
        return _lockEndTimes[account]; // Return the lock end time
    }

    // Function to get the total locked tokens
    function getTotalLockedTokens() public view returns (uint256) {
        return _totalLocked; // Return the total locked tokens
    }

    // Override the transfer function to include balance checks
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        require(balanceOf(_msgSender()) >= amount, "Transfer amount exceeds balance"); // Check if the sender has enough balance
        return super.transfer(to, amount); // Call the parent transfer function
    }

    // Override the transferFrom function to include balance checks
    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        require(balanceOf(from) >= amount, "Transfer amount exceeds balance"); // Check if the sender has enough balance
        return super.transferFrom(from, to, amount); // Call the parent transferFrom function
    }

    // Override the balanceOf function to include locked balances
    function balanceOf(address account) public view virtual override returns (uint256) {
        if (account == address(this)) {
            return super.balanceOf(address(this)) - _totalLocked; // Return the balance of the contract itself
        }
        return super.balanceOf(account) + _lockedBalances[account]; // Return the total balance including locked tokens
    }
}
