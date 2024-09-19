// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CappedCrowdsale is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public token;
    uint256 public rate;
    address payable public wallet;
    uint256 public tokensSold;
    uint256 public openingTime;
    uint256 public closingTime;
    uint256 public cap;

    constructor(
        uint256 _rate,
        address payable _wallet,
        IERC20 _token,
        uint256 _openingTime,
        uint256 _closingTime,
        uint256 _cap
    ) Ownable(msg.sender) {
        require(_rate > 0, "Rate must be greater than zero");
        require(_wallet != address(0), "Wallet cannot be the zero address");
        require(
            address(_token) != address(0),
            "Token cannot be the zero address"
        );
        require(
            _openingTime >= block.timestamp,
            "Opening time must be in the future"
        );
        require(
            _closingTime > _openingTime,
            "Closing time must be after opening time"
        );
        require(_cap > 0, "Cap must be greater than zero");

        rate = _rate;
        wallet = _wallet;
        token = _token;
        openingTime = _openingTime;
        closingTime = _closingTime;
        cap = _cap;
    }

    function buyTokens() public payable {
        uint256 weiAmount = msg.value;
        _preValidatePurchase(weiAmount);

        uint256 tokens = _getTokenAmount(weiAmount);
        tokensSold += tokens;

        _processPurchase(msg.sender, tokens);
        _forwardFunds();

        emit TokensPurchased(msg.sender, weiAmount, tokens);
    }

    function withdrawTokens() public onlyOwner {
        uint256 unsold = token.balanceOf(address(this));
        token.safeTransfer(owner(), unsold);
    }

    function hasCrowdsaleStarted() public view returns (bool) {
        return block.timestamp >= openingTime;
    }

    function hasCrowdsaleEnded() public view returns (bool) {
        return block.timestamp > closingTime;
    }

    function _preValidatePurchase(uint256 _weiAmount) internal view {
        require(_weiAmount != 0, "Wei amount cannot be zero");
        require(
            hasCrowdsaleStarted() && !hasCrowdsaleEnded(),
            "Crowdsale is not active"
        );
        require(
            tokensSold + _getTokenAmount(_weiAmount) <= cap,
            "CappedCrowdsale: cap exceeded"
        );
    }

    function _getTokenAmount(
        uint256 _weiAmount
    ) internal view returns (uint256) {
        return _weiAmount * rate;
    }

    function _processPurchase(
        address _beneficiary,
        uint256 _tokenAmount
    ) internal {
        token.safeTransfer(_beneficiary, _tokenAmount);
    }

    function _forwardFunds() internal {
        wallet.transfer(msg.value);
    }

    event TokensPurchased(
        address indexed purchaser,
        uint256 value,
        uint256 amount
    );
}
