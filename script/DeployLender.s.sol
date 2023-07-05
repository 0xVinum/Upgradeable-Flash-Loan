// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {LenderV1} from "../src/Lender/LenderV1.sol";
import {ERC1967Proxy} from "../lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployLender is Script {
    function run() external returns (address) {
        address proxy = deployLender();
        return proxy;
    }

    function deployLender() public returns (address) {
        vm.startBroadcast();
        LenderV1 lenderV1 = new LenderV1();
        ERC1967Proxy proxy = new ERC1967Proxy(address(lenderV1), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}