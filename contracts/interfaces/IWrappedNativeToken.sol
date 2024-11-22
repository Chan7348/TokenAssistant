// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

interface IWrappedNativeToken is IERC20Metadata {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}