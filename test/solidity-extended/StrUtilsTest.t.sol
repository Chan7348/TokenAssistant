// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;

import "forge-std/Test.sol";
import {StrUtils} from "./StrUtils.sol";

contract StrUtilsTest is Test {
    using StrUtils for string;

    function testParseUnits() public {
        assertEq(StrUtils.parseUnits("123", 2), 12300);
        assertEq(StrUtils.parseUnits("12300", 2), 1230000);
        assertEq(StrUtils.parseUnits("123.00", 2), 12300);
        assertEq(StrUtils.parseUnits("123.456", 3), 123456);
        assertEq(StrUtils.parseUnits("123.456", 5), 12345600);
        assertEq(StrUtils.parseSignedUnits("-123.456", 3), -123456);
        assertEq(StrUtils.parseSignedUnits("-123.456", 5), -12345600);
    }

    function testWadToString() public {
        assertTrue(StrUtils.wadToString(1 ether).equal("1.0"));
        assertTrue(StrUtils.wadToString(0.5 ether).equal("0.5"));
        assertTrue(StrUtils.wadToString(0.456 ether).equal("0.456"));
        assertTrue(StrUtils.wadToString(0.25 ether).equal("0.25"));
        assertTrue(StrUtils.wadToString(0.125 ether).equal("0.125"));
        assertTrue(StrUtils.wadToString(1.003 ether).equal("1.003"));
        assertTrue(StrUtils.wadToString(3.1415926 ether).equal("3.1415926"));
    }
}
