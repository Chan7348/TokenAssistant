// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

struct BlockInfo {
    uint height;
    uint timestamp;
}

struct TokenMetaInfo {
    string symbol;
    string name;
    uint8 decimals;
    address token;
}

struct Erc721MetaInfo {
    string symbol;
    string name;
    string tokenURI;
    uint256 tokenId;
    address token;
}

struct Erc1155MetaInfo {
    string tokenURI;
    uint256 tokenId;
    address token;
}