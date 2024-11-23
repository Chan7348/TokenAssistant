// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;

library StorageArray {
    // delete arr[index] in storage
    // Note that simply `delete arr[index]` won't reduce the length of array
    function del(uint48[] storage arr, uint index) internal {
        if (arr.length == 0) {
            revert("empty array");
        } else if (arr.length == 1) {
            require (index == 0, "Out of bound");
            arr.pop();
        } else { // arr.length >= 2
            for (uint i = index; i < arr.length - 1; ++i) {
                arr[i] = arr[i + 1];
            }
            arr.pop();
        }
    }

    function find(uint48[] storage arr, uint48 item) internal pure returns (uint) {
        return Array.find(arr, item); // reuse Array.find() which is for memory array
    }
}

library Array {
    // push item into arr in memory
    function push(uint48[] memory arr, uint48 item) internal pure returns(uint48[] memory res) {
        uint48[] memory temp = new uint48[](arr.length + 1);
        for (uint i = 0; i < arr.length; i++) temp[i] = arr[i];
        temp[arr.length] = item;
        return temp;
    }

    function push(address[] memory arr, address item) internal pure returns(address[] memory res) {
        address[] memory temp = new address[](arr.length + 1);
        for (uint i = 0; i < arr.length; i++) temp[i] = arr[i];
        temp[arr.length] = item;
        return temp;
    }

    // delete arr[index] in memory
    function del(uint48[] memory arr, uint index) internal pure returns(uint48[] memory res) {
        uint48[] memory temp = new uint48[](arr.length - 1);
        for (uint i = 0; i < index; ++i) {
            temp[i] = arr[i];
        }
        for (uint i = index; i < arr.length - 1; ++i) {
            temp[i] = arr[i + 1];
        }
        return temp;
    }


    function find(uint48[] memory arr, uint48 item) internal pure returns (uint) {
        for (uint i = 0; i < arr.length; ++i) {
            if (arr[i] == item) {
                return i;
            }
        }
        revert("item not found");
    }

    // convert fixed length array to dynamic length array
    // for string array
    function toDynamic(string[1] memory arr) internal pure returns (string[] memory res) {
        res = new string[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(string[2] memory arr) internal pure returns (string[] memory res) {
        res = new string[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(string[3] memory arr) internal pure returns (string[] memory res) {
        res = new string[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(string[4] memory arr) internal pure returns (string[] memory res) {
        res = new string[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(string[5] memory arr) internal pure returns (string[] memory res) {
        res = new string[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    function toDynamic(string[6] memory arr) internal pure returns (string[] memory res) {
        res = new string[](6);
        for (uint i = 0; i < 6; i++) res[i] = arr[i];
    }

    // for address array
    function toDynamic(address[1] memory arr) internal pure returns (address[] memory res) {
        res = new address[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(address[2] memory arr) internal pure returns (address[] memory res) {
        res = new address[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(address[3] memory arr) internal pure returns (address[] memory res) {
        res = new address[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(address[4] memory arr) internal pure returns (address[] memory res) {
        res = new address[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(address[5] memory arr) internal pure returns (address[] memory res) {
        res = new address[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    function toDynamic(address[6] memory arr) internal pure returns (address[] memory res) {
        res = new address[](6);
        for (uint i = 0; i < 6; i++) res[i] = arr[i];
    }

    function toDynamic(address[7] memory arr) internal pure returns (address[] memory res) {
        res = new address[](7);
        for (uint i = 0; i < 7; i++) res[i] = arr[i];
    }

    function toDynamic(address[8] memory arr) internal pure returns (address[] memory res) {
        res = new address[](8);
        for (uint i = 0; i < 8; i++) res[i] = arr[i];
    }

    function toDynamic(address[9] memory arr) internal pure returns (address[] memory res) {
        res = new address[](9);
        for (uint i = 0; i < 9; i++) res[i] = arr[i];
    }

    function toDynamic(address payable[1] memory arr) internal pure returns (address payable[] memory res) {
        res = new address payable[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(address payable[2] memory arr) internal pure returns (address payable[] memory res) {
        res = new address payable[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(address payable[3] memory arr) internal pure returns (address payable[] memory res) {
        res = new address payable[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(address payable[4] memory arr) internal pure returns (address payable[] memory res) {
        res = new address payable[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(address payable[5] memory arr) internal pure returns (address payable[] memory res) {
        res = new address payable[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    function toDynamic(address payable[6] memory arr) internal pure returns (address payable[] memory res) {
        res = new address payable[](6);
        for (uint i = 0; i < 6; i++) res[i] = arr[i];
    }

    function toDynamic(address payable[7] memory arr) internal pure returns (address payable[] memory res) {
        res = new address payable[](7);
        for (uint i = 0; i < 7; i++) res[i] = arr[i];
    }

    function toDynamic(address payable[8] memory arr) internal pure returns (address payable[] memory res) {
        res = new address payable[](8);
        for (uint i = 0; i < 8; i++) res[i] = arr[i];
    }

    function toDynamic(address payable[9] memory arr) internal pure returns (address payable[] memory res) {
        res = new address payable[](9);
        for (uint i = 0; i < 9; i++) res[i] = arr[i];
    }

    // for bytes32 array
    function toDynamic(bytes32[1] memory arr) internal pure returns (bytes32[] memory res) {
        res = new bytes32[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(bytes32[2] memory arr) internal pure returns (bytes32[] memory res) {
        res = new bytes32[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(bytes32[3] memory arr) internal pure returns (bytes32[] memory res) {
        res = new bytes32[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(bytes32[4] memory arr) internal pure returns (bytes32[] memory res) {
        res = new bytes32[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    // for uint array
    function toDynamic(uint[1] memory arr) internal pure returns (uint[] memory res) {
        res = new uint[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(uint[2] memory arr) internal pure returns (uint[] memory res) {
        res = new uint[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(uint[3] memory arr) internal pure returns (uint[] memory res) {
        res = new uint[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(uint[4] memory arr) internal pure returns (uint[] memory res) {
        res = new uint[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(uint[5] memory arr) internal pure returns (uint[] memory res) {
        res = new uint[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    // for int array
    function toDynamic(int[1] memory arr) internal pure returns (int[] memory res) {
        res = new int[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(int[2] memory arr) internal pure returns (int[] memory res) {
        res = new int[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(int[3] memory arr) internal pure returns (int[] memory res) {
        res = new int[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(int[4] memory arr) internal pure returns (int[] memory res) {
        res = new int[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(int[5] memory arr) internal pure returns (int[] memory res) {
        res = new int[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    // for uint128 array
    function toDynamic(uint128[1] memory arr) internal pure returns (uint128[] memory res) {
        res = new uint128[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(uint128[2] memory arr) internal pure returns (uint128[] memory res) {
        res = new uint128[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(uint128[3] memory arr) internal pure returns (uint128[] memory res) {
        res = new uint128[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(uint128[4] memory arr) internal pure returns (uint128[] memory res) {
        res = new uint128[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(uint128[5] memory arr) internal pure returns (uint128[] memory res) {
        res = new uint128[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    // for uint48 array
    function toDynamic(uint48[1] memory arr) internal pure returns (uint48[] memory res) {
        res = new uint48[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(uint48[2] memory arr) internal pure returns (uint48[] memory res) {
        res = new uint48[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(uint48[3] memory arr) internal pure returns (uint48[] memory res) {
        res = new uint48[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(uint48[4] memory arr) internal pure returns (uint48[] memory res) {
        res = new uint48[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(uint48[5] memory arr) internal pure returns (uint48[] memory res) {
        res = new uint48[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    // for uint32 array
    function toDynamic(uint32[1] memory arr) internal pure returns (uint32[] memory res) {
        res = new uint32[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(uint32[2] memory arr) internal pure returns (uint32[] memory res) {
        res = new uint32[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(uint32[3] memory arr) internal pure returns (uint32[] memory res) {
        res = new uint32[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(uint32[4] memory arr) internal pure returns (uint32[] memory res) {
        res = new uint32[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(uint32[5] memory arr) internal pure returns (uint32[] memory res) {
        res = new uint32[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    // for int24 array
    function toDynamic(int24[1] memory arr) internal pure returns (int24[] memory res) {
        res = new int24[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(int24[2] memory arr) internal pure returns (int24[] memory res) {
        res = new int24[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(int24[3] memory arr) internal pure returns (int24[] memory res) {
        res = new int24[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(int24[4] memory arr) internal pure returns (int24[] memory res) {
        res = new int24[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(int24[5] memory arr) internal pure returns (int24[] memory res) {
        res = new int24[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    // for uint24 array
    function toDynamic(uint24[1] memory arr) internal pure returns (uint24[] memory res) {
        res = new uint24[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(uint24[2] memory arr) internal pure returns (uint24[] memory res) {
        res = new uint24[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(uint24[3] memory arr) internal pure returns (uint24[] memory res) {
        res = new uint24[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(uint24[4] memory arr) internal pure returns (uint24[] memory res) {
        res = new uint24[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(uint24[5] memory arr) internal pure returns (uint24[] memory res) {
        res = new uint24[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    // for int16 array
    function toDynamic(int16[1] memory arr) internal pure returns (int16[] memory res) {
        res = new int16[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(int16[2] memory arr) internal pure returns (int16[] memory res) {
        res = new int16[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(int16[3] memory arr) internal pure returns (int16[] memory res) {
        res = new int16[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(int16[4] memory arr) internal pure returns (int16[] memory res) {
        res = new int16[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(int16[5] memory arr) internal pure returns (int16[] memory res) {
        res = new int16[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    // for uint8 array
    function toDynamic(uint8[1] memory arr) internal pure returns (uint8[] memory res) {
        res = new uint8[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(uint8[2] memory arr) internal pure returns (uint8[] memory res) {
        res = new uint8[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(uint8[3] memory arr) internal pure returns (uint8[] memory res) {
        res = new uint8[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(uint8[4] memory arr) internal pure returns (uint8[] memory res) {
        res = new uint8[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(uint8[5] memory arr) internal pure returns (uint8[] memory res) {
        res = new uint8[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    // for bytes array
    function toDynamic(bytes[1] memory arr) internal pure returns (bytes[] memory res) {
        res = new bytes[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(bytes[2] memory arr) internal pure returns (bytes[] memory res) {
        res = new bytes[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(bytes[3] memory arr) internal pure returns (bytes[] memory res) {
        res = new bytes[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(bytes[4] memory arr) internal pure returns (bytes[] memory res) {
        res = new bytes[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(bytes[5] memory arr) internal pure returns (bytes[] memory res) {
        res = new bytes[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    // for bool array
    function toDynamic(bool[1] memory arr) internal pure returns (bool[] memory res) {
        res = new bool[](1);
        for (uint i = 0; i < 1; i++) res[i] = arr[i];
    }

    function toDynamic(bool[2] memory arr) internal pure returns (bool[] memory res) {
        res = new bool[](2);
        for (uint i = 0; i < 2; i++) res[i] = arr[i];
    }

    function toDynamic(bool[3] memory arr) internal pure returns (bool[] memory res) {
        res = new bool[](3);
        for (uint i = 0; i < 3; i++) res[i] = arr[i];
    }

    function toDynamic(bool[4] memory arr) internal pure returns (bool[] memory res) {
        res = new bool[](4);
        for (uint i = 0; i < 4; i++) res[i] = arr[i];
    }

    function toDynamic(bool[5] memory arr) internal pure returns (bool[] memory res) {
        res = new bool[](5);
        for (uint i = 0; i < 5; i++) res[i] = arr[i];
    }

    function toDynamic(bool[6] memory arr) internal pure returns (bool[] memory res) {
        res = new bool[](6);
        for (uint i = 0; i < 6; i++) res[i] = arr[i];
    }

    function toDynamic(bool[7] memory arr) internal pure returns (bool[] memory res) {
        res = new bool[](7);
        for (uint i = 0; i < 7; i++) res[i] = arr[i];
    }

    function toDynamic(bool[8] memory arr) internal pure returns (bool[] memory res) {
        res = new bool[](8);
        for (uint i = 0; i < 8; i++) res[i] = arr[i];
    }

    function toDynamic(bool[9] memory arr) internal pure returns (bool[] memory res) {
        res = new bool[](9);
        for (uint i = 0; i < 9; i++) res[i] = arr[i];
    }
}