// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20WithTimelock is ERC20, Ownable {
    mapping(address => uint256) private _lockedBalances;
    mapping(address => uint256) private _lockEndTimes;

    event TokensLocked(address indexed account, uint256 amount, uint256 unlockTime);
    event TokensUnlocked(address indexed account, uint256 amount);

    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address initialOwner,
        uint256 lockDuration
    ) ERC20(name, symbol) Ownable(initialOwner) {
        _mintAndLock(initialOwner, initialSupply, lockDuration);
    }

    function _mintAndLock(address account, uint256 amount, uint256 lockDuration) private {
        _mint(address(this), amount);
        _lockedBalances[account] = amount;
        _lockEndTimes[account] = block.timestamp + lockDuration;
        emit TokensLocked(account, amount, _lockEndTimes[account]);
    }

    function unlockTokens() public {
        require(_lockEndTimes[_msgSender()] <= block.timestamp, "Tokens are still locked");
        require(_lockedBalances[_msgSender()] > 0, "No locked tokens");

        uint256 amountToUnlock = _lockedBalances[_msgSender()];
        _lockedBalances[_msgSender()] = 0;
        _transfer(address(this), _msgSender(), amountToUnlock);

        emit TokensUnlocked(_msgSender(), amountToUnlock);
    }

    function getLockedBalance(address account) public view returns (uint256) {
        return _lockedBalances[account];
    }

    function getLockEndTime(address account) public view returns (uint256) {
        return _lockEndTimes[account];
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        require(balanceOf(_msgSender()) >= amount, "Transfer amount exceeds balance");
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        require(balanceOf(from) >= amount, "Transfer amount exceeds balance");
        return super.transferFrom(from, to, amount);
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        if (account == address(this)) {
            return super.balanceOf(account) - totalSupply();
        }
        return super.balanceOf(account) + _lockedBalances[account];
    }
}
