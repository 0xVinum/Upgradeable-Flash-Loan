// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {LenderV1} from "../src/Lender/LenderV1.sol";
import {LenderV2} from "../src/Lender/LenderV2.sol";
import {ERC1967Proxy} from "../lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";

contract UpgradeLender is Script {
    function run() external returns (address) {
        address mostRecentlyDeployedProxy = DevOpsTools
            .get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        LenderV2 lenderV2 = new LenderV2();
        vm.stopBroadcast();
        address proxy = upgradeLender(mostRecentlyDeployedProxy, address(lenderV2));
        return proxy;
    }

    function upgradeLender(
        address proxyAddress,
        address newImpl
    ) public returns (address) {
        vm.startBroadcast();
        LenderV1 proxy = LenderV1(proxyAddress);
        proxy.upgradeTo(address(newImpl));
        vm.stopBroadcast();
        return address(proxy);
    }
}