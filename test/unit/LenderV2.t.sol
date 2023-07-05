// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {ERC20Mock} from "../mock/ERC20Mock.sol";
import {LenderV1, UUPSUpgradeable} from "../../src/Lender/LenderV1.sol";
import {LenderV2} from "../../src/Lender/LenderV2.sol";
import {Borrower} from "../../src/Borrower/Borrower.sol";

contract LenderV2Test is Test {
    error Borrower__UntrustedLoanInitiator();

    ERC20Mock public erc20Mock;
    LenderV2 public lender;
    Borrower public borrower;

    address[] public supportedTokens;
    address public owner = address(1);

    function setUp() public {
        erc20Mock = new ERC20Mock();
        lender = new LenderV2();
        borrower = new Borrower(lender);

        supportedTokens = [address(erc20Mock)];

        erc20Mock.transfer(address(lender), 100);
        erc20Mock.transfer(address(borrower), 100);

        vm.startPrank(owner);
        lender.initialize(supportedTokens, 1000);
        lender.allowPauser(owner);
        lender.pause();
    }

    function testFlashLoan() public {
        lender.unpause();
        vm.startPrank(address(1));
        vm.expectRevert(Borrower__UntrustedLoanInitiator.selector);
        lender.flashLoan(borrower, address(erc20Mock), 10, "");
        vm.stopPrank();
    }

    function testFlashFee() public {
        lender.unpause();
        uint256 fee = lender.flashFee(address(erc20Mock), 1000);
        assertEq(fee, 100);
    }

    function testMaxFlashLoan() public {
        lender.unpause();
        uint256 maxflashloan = lender.maxFlashLoan(address(erc20Mock));
        assertEq(maxflashloan, 100);
    }
}
