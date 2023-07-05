// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployLender} from "../../script/DeployLender.s.sol";
import {UpgradeLender} from "../../script/UpgradeLender.s.sol";
import {ERC20Mock} from "../mock/ERC20Mock.sol";
import {LenderV1} from "../../src/Lender/LenderV1.sol";
import {LenderV2} from "../../src/Lender/LenderV2.sol";
import {Borrower} from "../../src/Borrower/Borrower.sol";
import {ERC1967Proxy} from "../../lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract LenderV1Test is Test {
    error Borrower__UntrustedLoanInitiator();

    ERC20Mock public erc20Mock;
    LenderV1 public lenderV1;

    address[] public supportedTokens;

    function setUp() public {
        erc20Mock = new ERC20Mock();
        lenderV1 = new LenderV1();

        supportedTokens = [address(erc20Mock)];

        erc20Mock.transfer(address(lenderV1), 100);
        lenderV1.initialize(supportedTokens, 1000);
    }

    function testFlashLoanMustRevert() public {
        Borrower borrower = new Borrower(lenderV1);
        erc20Mock.transfer(address(borrower), 100);

        vm.startPrank(address(1));
        vm.expectRevert(Borrower__UntrustedLoanInitiator.selector);
        lenderV1.flashLoan(borrower, address(erc20Mock), 10, "");
        vm.stopPrank();
    }

    function testFlashFee() public {
        uint256 fee = lenderV1.flashFee(address(erc20Mock), 1000);
        assertEq(fee, 100);
    }

    function testMaxFlashLoan() public {
        uint256 maxflashloan = lenderV1.maxFlashLoan(address(erc20Mock));
        assertEq(maxflashloan, 100);
    }

    function testUpgradeTo() public {
        // This test requires its own setup.
        DeployLender deployer = new DeployLender();
        UpgradeLender upgrader = new UpgradeLender();
        address proxyAddress = deployer.deployLender();
        LenderV2 lenderV2 = new LenderV2();

        vm.prank(LenderV1(proxyAddress).owner());
        LenderV1(proxyAddress).transferOwnership(msg.sender);
        upgrader.upgradeLender(proxyAddress, address(lenderV2));

        // ERC1967Proxy proxy = new ERC1967Proxy(address(lenderV1), "");
        // (bool success, ) = address(proxy).delegatecall(abi.encodeWithSignature("upgradeTo(address)", ""));
        // assertTrue(success);
    }
}
