// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PauseBase} from "./PauseBase.sol";
import {IPauseV2} from "../interfaces/IPauseV2.sol";
import {OwnableUpgradeable, Initializable} from "../../lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

abstract contract PauseV2 is PauseBase, IPauseV2 {
    mapping(address => bool) pauser;

    modifier onlyPauser() {
        require(pauser[msg.sender] == true);
        _;
    }

    function pause() external override onlyPauser {
        pauseInternal();
    }

    function unpause() external override onlyPauser {
        unpauseInternal();
    }

    function allowPauser(address _newPauser) public virtual override {
        pauser[_newPauser] = true;
    }

    uint256[49] private __gapPauseV2;
}
