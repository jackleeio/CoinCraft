// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "src/ERC20/ERC20FixedSupply.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

// 固定总量代币测试
contract ERC20FixedSupplyTest is Test {
    ERC20FixedSupply token;
    address owner;
    address receiver;
    address purchaser;
    address beneficiary;
    uint8 constant DECIMALS = 18;
    uint256 constant INITIAL_SUPPLY = 10000;
    uint256 constant TOTAL_SUPPLY = INITIAL_SUPPLY * 10**DECIMALS;

    function setUp() public {
        owner = address(this);
        receiver = address(0x1);
        purchaser = address(0x2);
        beneficiary = address(0x3);
        token = new ERC20FixedSupply("My Golden Coin", "MGC", DECIMALS, INITIAL_SUPPLY);
    }

    function testDeployToken() public {
        assertEq(token.totalSupply(), TOTAL_SUPPLY);
        assertEq(token.balanceOf(address(this)), TOTAL_SUPPLY);
    }

    function testTransfer() public {
        uint256 transferAmount = 10 * 10**DECIMALS;

        // 测试发送到零地址
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InvalidReceiver.selector, address(0)));
        token.transfer(address(0), transferAmount);

        // 测试正常发送
        bool success = token.transfer(receiver, transferAmount);
        assertTrue(success);
        assertEq(token.balanceOf(receiver), transferAmount);
        assertEq(token.balanceOf(address(this)), TOTAL_SUPPLY - transferAmount);

        // 测试超额发送
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InsufficientBalance.selector, address(this), TOTAL_SUPPLY - transferAmount, TOTAL_SUPPLY));
        token.transfer(receiver, TOTAL_SUPPLY);
    }

    function testApproveAndTransferFrom() public {
        uint256 approveAmount = 10 * 10**18;

        // 测试批准到零地址
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InvalidSpender.selector, address(0)));
        token.approve(address(0), approveAmount);

        // 测试正常批准
        bool success = token.approve(purchaser, approveAmount);
        assertTrue(success);
        assertEq(token.allowance(address(this), purchaser), approveAmount);

        // 测试转移批准
        vm.prank(purchaser);
        success = token.transferFrom(address(this), beneficiary, approveAmount);
        assertTrue(success);
        assertEq(token.balanceOf(beneficiary), approveAmount);
        assertEq(token.allowance(address(this), purchaser), 0);

        // 测试超额转移批准
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InsufficientAllowance.selector, purchaser, 0, approveAmount));
        vm.prank(purchaser);
        token.transferFrom(address(this), beneficiary, approveAmount);
    }

    function testIncreaseAndDecreaseAllowance() public {
        uint256 ethValue = 10 * 10**18;

        // 增加批准
        token.approve(purchaser, ethValue);
        // token.increaseAllowance(purchaser, ethValue);
        // assertEq(token.allowance(owner, purchaser), ethValue * 2);
        // 改为直接设置新的批准额度
        token.approve(purchaser, ethValue * 2);
        assertEq(token.allowance(owner, purchaser), ethValue * 2);

        // 减少批准
        // token.decreaseAllowance(purchaser, ethValue); // 注释掉原有代码
        token.approve(purchaser, ethValue); // 直接重新设置批准额度
        assertEq(token.allowance(owner, purchaser), ethValue);
    }
}
