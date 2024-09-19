// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleCrowdsale is Ownable {
    using SafeERC20 for IERC20;

    // Token contract address
    IERC20 public token;
    
    // Token price (how much wei per token)
    uint256 public rate;
    
    // Fundraising wallet address
    address payable public wallet;
    
    // Number of tokens sold
    uint256 public tokensSold;

    // Crowdsale start time
    uint256 public openingTime;
    
    // Crowdsale end time  
    uint256 public closingTime;

    constructor(
        uint256 _rate,
        address payable _wallet,
        IERC20 _token,
        uint256 _openingTime,
        uint256 _closingTime
    ) Ownable(msg.sender) {
        require(_rate > 0, "Rate must be greater than zero");
        require(_wallet != address(0), "Wallet cannot be the zero address");
        require(address(_token) != address(0), "Token cannot be the zero address");
        require(_openingTime >= block.timestamp, "Opening time must be in the future");
        require(_closingTime > _openingTime, "Closing time must be after opening time");

        rate = _rate;
        wallet = _wallet;
        token = _token;
        openingTime = _openingTime;
        closingTime = _closingTime;
    }

    // Buy tokens
    function buyTokens() public payable {
        uint256 weiAmount = msg.value;
        _preValidatePurchase(weiAmount);

        uint256 tokens = _getTokenAmount(weiAmount);

        tokensSold += tokens;

        _processPurchase(msg.sender, tokens);
        _forwardFunds();

        emit TokensPurchased(msg.sender, weiAmount, tokens);
    }

    // Withdraw unsold tokens
    function withdrawTokens() public onlyOwner {
        uint256 unsold = token.balanceOf(address(this));
        token.safeTransfer(owner(), unsold);
    }

    // Check if the crowdsale has started
    function hasCrowdsaleStarted() public view returns (bool) {
        return block.timestamp >= openingTime;
    }

    // Check if the crowdsale has ended
    function hasCrowdsaleEnded() public view returns (bool) {
        return block.timestamp > closingTime;
    }

    // Internal function: Validate purchase
    function _preValidatePurchase(uint256 _weiAmount) internal view {
        require(msg.sender != address(0), "Purchaser cannot be the zero address");
        require(_weiAmount != 0, "Wei amount cannot be zero");
        require(hasCrowdsaleStarted() && !hasCrowdsaleEnded(), "Crowdsale is not active");
    }

    // Internal function: Calculate token amount
    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
        return _weiAmount * rate;
    }

    // Internal function: Process purchase
    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
        token.safeTransfer(_beneficiary, _tokenAmount);
    }

    // Internal function: Forward funds
    function _forwardFunds() internal {
        wallet.transfer(msg.value);
    }

    // Event: Token purchase
    event TokensPurchased(address indexed purchaser, uint256 value, uint256 amount);
}
