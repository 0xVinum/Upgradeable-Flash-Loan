// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {ERC20Mock} from "../mock/ERC20Mock.sol";
import {Borrower} from "../../src/Borrower/Borrower.sol";
import {LenderV1} from "../../src/Lender/LenderV1.sol";

contract BorrowerTest is Test {
    error Borrower__UntrustedLender();

    ERC20Mock public erc20Mock;
    LenderV1 public lender;
    Borrower public borrower;

    address[] public supportedTokens;
    address public user = address(1);

    function setUp() public {
        erc20Mock = new ERC20Mock();
        lender = new LenderV1();
        borrower = new Borrower(lender);

        erc20Mock.transfer(address(lender), 100);
        erc20Mock.transfer(address(borrower), 100);
    }

    function testFlashBorrow() public {
        supportedTokens = [address(erc20Mock)];

        vm.startPrank(user);
        lender.initialize(supportedTokens, 1000);
        borrower.flashBorrow(address(erc20Mock), 10);
        vm.stopPrank();
    }

    function testOnFlashLoanMustRevert() public {
        vm.startPrank(user);
        vm.expectRevert(Borrower__UntrustedLender.selector);
        borrower.onFlashLoan(address(borrower), address(erc20Mock), 10, 1000, "");
        vm.stopPrank();
    }
}
