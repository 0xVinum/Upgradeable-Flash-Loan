# Upgradeable Flash Loan

This project intends to be a single-asset flash loan where the “Lender” contract can be upgraded to allow new features and bug fixes, in this case it was used to fix the pauseability mechanism.

Smart contracts are immutable by default, to allow for the addition of new features, this contract makes use of the Universal Upgradeable Proxy Standard (UUPS) as defined in the [ERC-1822](https://eips.ethereum.org/EIPS/eip-1822). For the mechanism of performing single-asset flash loans, the standard defined in [ERC-3156](https://eips.ethereum.org/EIPS/eip-3156) is used.
