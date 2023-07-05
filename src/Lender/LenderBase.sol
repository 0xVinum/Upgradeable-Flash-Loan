// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {IERC20Upgradeable} from "../../lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/IERC20Upgradeable.sol";
import {IERC3156FlashBorrower} from "../../lib/openzeppelin-contracts/contracts/interfaces/IERC3156FlashBorrower.sol";
import {IERC3156FlashLender} from "../../lib/openzeppelin-contracts/contracts/interfaces/IERC3156FlashLender.sol";
import {OwnableUpgradeable, Initializable} from "../../lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

abstract contract LenderBase is
    Initializable,
    OwnableUpgradeable,
    IERC3156FlashLender
{
    error Lender__UnsupportedCurrency();
    error Lender__TransferFailed();
    error Lender__CallbackFailed();
    error Lender__RepayFailed();

    bytes32 public immutable CALLBACK_SUCCESS =
        keccak256("ERC3156FlashBorrower.onFlashLoan");
    mapping(address => bool) public supportedTokens;
    uint256 public fee;

    /**
     * @param supportedTokens_ Token contracts supported for flash lending.
     * @param fee_ The percentage of the loan `amount` that needs to be repaid, in addition to `amount`.
     */

    function initialize(
        address[] memory supportedTokens_,
        uint256 fee_
    ) public initializer {
        for (uint256 i = 0; i < supportedTokens_.length; i++) {
            supportedTokens[supportedTokens_[i]] = true;
        }
        fee = fee_;
        __Ownable_init();
    }

    /**
     * @dev Loan `amount` tokens to `receiver`, and takes it back plus a `flashFee` after the callback.
     * @param receiver The contract receiving the tokens, needs to implement the `onFlashLoan(address user, uint256 amount, uint256 fee, bytes calldata)` interface.
     * @param token The loan currency.
     * @param amount The amount of tokens lent.
     * @param data A data parameter to be passed on to the `receiver` for any custom use.
     */

    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) public virtual override returns (bool) {
        if (!supportedTokens[token]){
            revert Lender__UnsupportedCurrency();
        }
        fee = _flashFee(token, amount);

        bool transfer = IERC20Upgradeable(token).transfer(
            address(receiver),
            amount
        );
        if (!transfer) {
            revert Lender__TransferFailed();
        }

        if (
            receiver.onFlashLoan(msg.sender, token, amount, fee, data) !=
            CALLBACK_SUCCESS
        ) {
            revert Lender__CallbackFailed();
        }

        bool repay = IERC20Upgradeable(token).transferFrom(
            address(receiver),
            address(this),
            amount + fee
        );
        if (!repay) {
            revert Lender__RepayFailed();
        }

        return true;
    }

    /**
     * @dev The fee to be charged for a given loan.
     * @param token The loan currency.
     * @param amount The amount of tokens lent.
     * @return The amount of `token` to be charged for the loan, on top of the returned principal.
     */

    function flashFee(
        address token,
        uint256 amount
    ) public virtual view override returns (uint256) {
        if (!supportedTokens[token]){
            revert Lender__UnsupportedCurrency();
        }        return _flashFee(token, amount);
    }

    /**
     * @dev The fee to be charged for a given loan. Internal function with no checks.
     * @param token The loan currency.
     * @param amount The amount of tokens lent.
     * @return The amount of `token` to be charged for the loan, on top of the returned principal.
     */

    function _flashFee(
        address token,
        uint256 amount
    ) internal view returns (uint256) {
        return (amount * fee) / 10000;
    }

    /**
     * @dev The amount of currency available to be lent.
     * @param token The loan currency.
     * @return The amount of `token` that can be borrowed.
     */

    function maxFlashLoan(
        address token
    ) public virtual view override returns (uint256) {
        return
            supportedTokens[token]
                ? IERC20Upgradeable(token).balanceOf(address(this))
                : 0;
    }
}
