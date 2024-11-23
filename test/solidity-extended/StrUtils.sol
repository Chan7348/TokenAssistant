// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";


library StrUtils {
    uint8 constant ASCII_0 = 48;
    uint8 constant ASCII_9 = 57;
    bytes16 private constant HEX_DIGITS = "0123456789abcdef";

    function isDigit(bytes1 char) internal pure returns (bool) {
        return (ASCII_0 <= uint8(char)) && (uint8(char) <= ASCII_9);
    }

    function _parseUnits(string memory str, uint8 exponent, uint start) private pure returns (uint) { unchecked {
        bytes memory b = bytes(str);
        uint decimals = 0;
        uint res = 0;
        uint len = bytes(str).length;
        uint i;
        for (i = start; i < len; i++) {
            if (b[i] == bytes1(".")) {
                i ++;
                break;
            }

            require(isDigit(b[i]), "not digit or dot");
            res = res * 10 + (uint8(b[i]) - ASCII_0);
        }
        if (i == len) {
            return res * 10 ** exponent;
        }
        else {
            decimals = len - i;
            require(decimals <= exponent, "too many decimals");
            for (; i < len; i++) {
                require(isDigit(b[i]), "not digit");
                res = res * 10 + (uint8(b[i]) - ASCII_0);
            }
            return res * 10 ** (exponent - decimals);
        }
    }}

    // uint(str) * (10 ** exponent)
    // str should not start with minus sign
    function parseUnits(string memory str, uint8 exponent) internal pure returns (uint) {
        return _parseUnits(str, exponent, 0);
    }

    // int(str) * (10 ** exponent)
    // str may start with plus or minus sign
    function parseSignedUnits(string memory str, uint8 exponent) internal pure returns (int) {
        bytes memory b = bytes(str);
        if (b[0] == bytes1("-")) {
            return -int(_parseUnits(str, exponent, 1));
        } else if (b[0] == bytes1("+")) {
            return int(_parseUnits(str, exponent, 1));
        } else {
            return int(_parseUnits(str, exponent, 0));
        }
    }

    function toString(uint x) internal pure returns (string memory) {
        return Strings.toString(x);
    }

    function toString(int x) internal pure returns (string memory) {
        if (x < 0) {
            return string.concat("-", Strings.toString(uint(-x)));
        } else {
            return Strings.toString(uint(x));
        }
    }

    function equal(string memory str1, string memory str2) internal pure returns (bool) {
        // We ignore the possibility of hash collision here
        return keccak256(bytes(str1)) == keccak256(bytes(str2));
    }

    // Adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
    function fractionToString(uint value, uint decimals) internal pure returns (string memory) {
        require(value < 10**decimals, "value too large");

        uint length = decimals;
        while (value % 10 == 0) {
            value /= 10;
            length--;
            if (length == 0) return "0";
        }
        unchecked {
            string memory buffer = new string(length);
            uint256 ptr;
            assembly {
                ptr := add(buffer, add(32, length))
            }
            for (uint i = 0; i < length; i++) {
                ptr--;
                assembly {
                    mstore8(ptr, byte(mod(value, 10), HEX_DIGITS))
                }
                value /= 10;
            }
            return buffer;
        }
    }

    // string(wad / 1e18)
    // e.g. uint(5e17) => "0.5"
    function wadToString(uint wad) public pure returns (string memory) {
        uint integer = wad / (10**18);
        uint fraction = wad % (10**18);
        return string.concat(Strings.toString(integer), ".", fractionToString(fraction, 18));
    }
}

