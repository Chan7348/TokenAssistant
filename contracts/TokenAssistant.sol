// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import { IERC20, IERC20Metadata } from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import { IWrappedNativeToken } from "./interfaces/IWrappedNativeToken.sol";
import { IERC721, IERC721Metadata } from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import { IERC1155, IERC1155MetadataURI } from "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import "./Types.sol";

contract TokenAssistant is ReentrancyGuard {
    address wrappedNativeToken;

    error NonMsgValue();
    error ArgumentLengthMismatch();
    error AmountAndMsgValueMismatch();
    error RejectDirectTransferNativeTokenToContract();

    constructor(address _wrappedNativeToken) {
        wrappedNativeToken = _wrappedNativeToken;
    }


    function disperseNative(
        address payable[] calldata recipients, uint[] calldata values
    ) public payable nonReentrant {
        require(msg.value != 0, NonMsgValue());
        require(recipients.length == values.length, ArgumentLengthMismatch());
        for (uint i = 0; i < recipients.length; i++) {
            Address.sendValue(recipients[i], values[i]);
        }

        uint balance = address(this).balance;
        if (balance > 0) Address.sendValue(payable(msg.sender), balance);
    }

    function disperseErc20(address token, address[] calldata recipients, uint[] calldata values) public nonReentrant {
        require(recipients.length == values.length, ArgumentLengthMismatch());
        uint total = 0;
        for (uint i = 0; i < recipients.length; i++) {
            total += values[i];
        }

        SafeERC20.safeTransferFrom(IERC20(token), msg.sender, address(this), total);

        for (uint i = 0; i < recipients.length; i++) {
            SafeERC20.safeTransfer(IERC20(token), recipients[i], values[i]);
        }
    }

    function disperseErc721(
        address token, uint[] calldata tokenIds, address[] calldata recipients
    ) public nonReentrant {
        uint length = tokenIds.length;
        require(length == recipients.length, ArgumentLengthMismatch());
        for (uint i = 0; i < length; i++) {
            IERC721(token).safeTransferFrom(msg.sender, recipients[i], tokenIds[i]);
        }
    }

    function disperseErc1155(
        address token, uint[] calldata tokenIds, address[] calldata recipients, uint[] calldata amounts
    ) public nonReentrant {
        uint length = tokenIds.length;
        require(length == recipients.length && length == amounts.length, ArgumentLengthMismatch());

        for (uint i = 0; i < length; i++) {
            IERC1155(token).safeTransferFrom(msg.sender, recipients[i], tokenIds[i], amounts[i], '');
        }
    }

    function wrapNativeToken(uint amount, address to) public payable nonReentrant {
        require(msg.value == amount, AmountAndMsgValueMismatch());
        IWrappedNativeToken(wrappedNativeToken).deposit{value: msg.value}();
        SafeERC20.safeTransfer(IERC20(wrappedNativeToken), to, amount);
    }

    function unwrapNativeToken(uint amount, address payable to) external payable nonReentrant {
        SafeERC20.safeTransferFrom(IERC20(wrappedNativeToken), msg.sender, address(this), amount);
        IWrappedNativeToken(wrappedNativeToken).withdraw(amount);
        Address.sendValue(to, amount);
    }

    // also native token balance query, just use address(0) as token address for native token
    function balanceOfERC20Batch(
        address[] calldata tokens, address[] calldata targets
    ) public view returns (BlockInfo memory blockInfo, uint[][] memory balances) {
        balances = new uint[][](targets.length);
        for (uint i = 0; i < targets.length; ++i) {
            balances[i] = new uint[](tokens.length);

            for(uint j = 0; j < tokens.length; ++j) {
                balances[i][j] = tokens[j] == address(0) ? targets[i].balance : IERC20(tokens[j]).balanceOf(targets[i]);
            }
        }
        blockInfo = BlockInfo(block.number, block.timestamp);
    }

    function metaOfERC20Batch(address[] calldata tokens) public view returns (TokenMetaInfo[] memory) {
        TokenMetaInfo[] memory res = new TokenMetaInfo[](tokens.length);
        for (uint i = 0; i < tokens.length; ++i) {
            res[i] = TokenMetaInfo({
                symbol: IERC20Metadata(tokens[i]).symbol(),
                name: IERC20Metadata(tokens[i]).name(),
                decimals: IERC20Metadata(tokens[i]).decimals(),
                token: tokens[i]
            });
        }
        return res;
    }

    function balanceOfErc721Batch(
        address[] calldata tokens, address[] calldata targets
    ) public view returns (BlockInfo memory blockInfo, uint[][] memory balances) {
        balances = new uint[][](targets.length);
        for (uint i = 0; i < targets.length; ++i) {
            balances[i] = new uint[](tokens.length);

            for (uint j = 0; j < tokens.length; ++j) {
                balances[i][j] = IERC721(tokens[j]).balanceOf(targets[i]);
            }
        }
        blockInfo = BlockInfo(block.number, block.timestamp);
    }

    function metaOfErc721Batch(
        address[] calldata tokens, uint[] calldata tokenIds
    ) public view returns (Erc721MetaInfo[] memory) {
        require(tokens.length == tokenIds.length, ArgumentLengthMismatch());
        Erc721MetaInfo[] memory res = new Erc721MetaInfo[](tokens.length);
        for (uint i = 0; i < tokens.length; ++i) {
            // according to https://eips.ethereum.org/EIPS/eip-721
            // NFTs assigned to zero address are considered invalid,
            // and queries about them do throw, hence the try catch here
            try IERC721(tokens[i]).ownerOf(tokenIds[i]) {
                res[i] = Erc721MetaInfo({
                    symbol: IERC721Metadata(tokens[i]).symbol(),
                    name: IERC721Metadata(tokens[i]).name(),
                    tokenURI: IERC721Metadata(tokens[i]).tokenURI(tokenIds[i]),
                    tokenId: tokenIds[i],
                    token: tokens[i]
                });
            } catch {} // if tokenId does not exist on specific token, then all fields of Erc721MetaInfo are left empty
        }
        return res;
    }

    function balanceOfErc1155Batch(
        address token, address[] calldata targets, uint[] calldata tokenIds
    ) public view returns (BlockInfo memory blockInfo, uint[][] memory balances) {
        balances = new uint[][](targets.length);
        for (uint i = 0; i < targets.length; ++i) {
            balances[i] = new uint[](tokenIds.length);

            for(uint j = 0; j < tokenIds.length; ++j) {
                balances[i][j] = IERC1155(token).balanceOf(targets[i], tokenIds[j]);
            }
        }
        blockInfo = BlockInfo(block.number, block.timestamp);
    }

    function metaOfErc1155Batch(
        address[] calldata tokens, uint[] calldata tokenIds
    ) public view returns(Erc1155MetaInfo[] memory) {
        require(tokens.length == tokenIds.length, ArgumentLengthMismatch());
        Erc1155MetaInfo[] memory res = new Erc1155MetaInfo[](tokens.length);
        for (uint i = 0; i < tokens.length; ++i) {
            res[i] = Erc1155MetaInfo({
                tokenURI: IERC1155MetadataURI(tokens[i]).uri(tokenIds[i]),
                tokenId: tokenIds[i],
                token: tokens[i]
            });
        }
        return res;
    }

    receive() external payable {
        require(msg.sender == wrappedNativeToken, RejectDirectTransferNativeTokenToContract());
    }
}