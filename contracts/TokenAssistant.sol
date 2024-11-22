// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import { IERC20, IERC20Metadata } from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import { IWrappedNativeToken } from "./interfaces/IWrappedNativeToken.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { IERC1155 } from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import "./Types.sol";

contract TokenAssistant is ReentrancyGuard {
    address wrappedNativeToken;

    error ArgumentLengthMissmatch();
    error AmountAndMsgValueMissmatch();

    constructor(address _wrappedNativeToken) {
        wrappedNativeToken = _wrappedNativeToken;
    }

    function disperseNative(address payable[] calldata recipients, uint[] calldata values) public payable nonReentrant {
        require(recipients.length == values.length, ArgumentLengthMissmatch());
        for (uint i = 0; i < recipients.length; i++) {
            Address.sendValue(recipients[i], values[i]);
        }

        if (address(this).balance > 0) Address.sendValue(payable(msg.sender), address(this).balance);
    }

    function disperseERC20(address token, address[] calldata recipients, uint[] calldata values) public nonReentrant {
        require(recipients.length == values.length, ArgumentLengthMissmatch());
        for (uint i = 0; i < values.length; i++) {
            SafeERC20.safeTransferFrom(IERC20(token), msg.sender, recipients[i], values[i]);
        }

        if (IERC20(token).balanceOf(address(this)) > 0) SafeERC20.safeTransfer(IERC20(token), msg.sender, IERC20(token).balanceOf(address(this)));
    }

    function disperseERC721(address token, uint[] calldata tokenIds, address[] calldata recipients) public nonReentrant {
        uint length = tokenIds.length;
        require(length == recipients.length, ArgumentLengthMissmatch());
        for (uint i = 0; i < length; i++) {
            IERC721(token).safeTransferFrom(msg.sender, recipients[i], tokenIds[i]);
        }
    }

    function disperseERC1155(address token, uint[] calldata tokenIds, address[] calldata recipients, uint[] calldata amounts) public nonReentrant {
        uint length = tokenIds.length;
        require(length == recipients.length && length == amounts.length, ArgumentLengthMissmatch());
        for (uint i = 0; i < length; i++) {
            IERC1155(token).safeTransferFrom(msg.sender, recipients[i], tokenIds[i], amounts[i], '');
        }
    }

    function wrapNativeToken(uint amount, address to) public payable nonReentrant {
        require(msg.value == amount, AmountAndMsgValueMissmatch());
        IWrappedNativeToken(wrappedNativeToken).deposit{value: msg.value}();
        SafeERC20.safeTransfer(IERC20(wrappedNativeToken), to, amount);
    }

    function unwrapNativeToken(uint amount, address payable to) public nonReentrant {
        SafeERC20.safeTransferFrom(IERC20(wrappedNativeToken), msg.sender, address(this), amount);
        IWrappedNativeToken(wrappedNativeToken).withdraw(amount);
        Address.sendValue(to, amount);
    }

    // Also support Native Token balance query, just specify the address with address(0)
    function balanceOfTokenBatch(address[] calldata tokens, address[] calldata targets) public view returns (BlockInfo memory blockInfo, uint[][] memory balances) {
        balances = new uint[][](targets.length);
        for (uint i = 0; i < targets.length; i++) {
            balances[i] = new uint[](tokens.length);

            for(uint j = 0; j < tokens.length;i++) {
                balances[i][j] = tokens[j] == address(0) ? targets[i].balance : IERC20(tokens[j]).balanceOf(targets[i]);
            }
        }

        blockInfo = BlockInfo(block.number, block.timestamp);
    }
}