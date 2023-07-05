// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./LenderBase.sol";

import {PauseV2} from "../Pause/PauseV2.sol";
import {UUPSUpgradeable} from "../../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";

contract LenderV2 is LenderBase, PauseV2, UUPSUpgradeable {
    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) public override whenNotPaused returns (bool) {
        return super.flashLoan(receiver, token, amount, data);
    }

    function flashFee(
        address token,
        uint256 amount
    ) public view override whenNotPaused returns (uint256) {
        return super._flashFee(token, amount);
    }

    function maxFlashLoan(
        address token
    ) public view override whenNotPaused returns (uint256) {
        return super.maxFlashLoan(token);
    }

    function allowPauser(address _newPauser) public virtual override onlyOwner {
        pauser[_newPauser] = true;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal virtual override {}
}
