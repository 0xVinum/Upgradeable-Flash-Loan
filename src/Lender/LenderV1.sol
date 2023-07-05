// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {LenderBase} from "./LenderBase.sol";
import {PauseV1} from "../Pause/PauseV1.sol";
import {UUPSUpgradeable} from "../../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";

contract LenderV1 is LenderBase, PauseV1, UUPSUpgradeable {
    function _authorizeUpgrade(
        address newImplementation
    ) internal virtual override {}
}