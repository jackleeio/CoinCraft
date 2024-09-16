// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleCrowdsale is Ownable {
    using SafeERC20 for IERC20;

    // 代币合约地址
    IERC20 public token;
    
    // 代币价格(每个代币多少wei)
    uint256 public rate;
    
    // 筹款钱包地址
    address payable public wallet;
    
    // 已售出的代币数量
    uint256 public tokensSold;

    // 众筹开始时间
    uint256 public openingTime;
    
    // 众筹结束时间  
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

    // 购买代币
    function buyTokens() public payable {
        uint256 weiAmount = msg.value;
        _preValidatePurchase(weiAmount);

        uint256 tokens = _getTokenAmount(weiAmount);

        tokensSold += tokens;

        _processPurchase(msg.sender, tokens);
        _forwardFunds();

        emit TokensPurchased(msg.sender, weiAmount, tokens);
    }

    // 提取未售出的代币
    function withdrawTokens() public onlyOwner {
        uint256 unsold = token.balanceOf(address(this));
        token.safeTransfer(owner(), unsold);
    }

    // 检查众筹是否开始
    function hasCrowdsaleStarted() public view returns (bool) {
        return block.timestamp >= openingTime;
    }

    // 检查众筹是否结束
    function hasCrowdsaleEnded() public view returns (bool) {
        return block.timestamp > closingTime;
    }

    // 内部函数: 验证购买
    function _preValidatePurchase(uint256 _weiAmount) internal view {
        require(msg.sender != address(0), "Purchaser cannot be the zero address");
        require(_weiAmount != 0, "Wei amount cannot be zero");
        require(hasCrowdsaleStarted() && !hasCrowdsaleEnded(), "Crowdsale is not active");
    }

    // 内部函数: 计算代币数量
    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
        return _weiAmount * rate;
    }

    // 内部函数: 处理购买
    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
        token.safeTransfer(_beneficiary, _tokenAmount);
    }

    // 内部函数: 转发资金
    function _forwardFunds() internal {
        wallet.transfer(msg.value);
    }

    // 事件: 代币购买
    event TokensPurchased(address indexed purchaser, uint256 value, uint256 amount);
}
