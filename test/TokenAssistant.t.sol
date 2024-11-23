// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "forge-std/Test.sol";
import "contracts/TokenAssistant.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./solidity-extended/Array.sol";

contract ERC20Instance is ERC20 {
    uint8 private immutable _decimals;
    constructor(string memory _name, string memory _symbol, uint8 __decimals) ERC20(_name, _symbol) {
        _decimals = __decimals;
    }

    function decimals() public view override returns (uint8) {
        return _decimals;
    }
}

contract ERC721Instance is ERC721 {
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}
}

contract ERC1155Instance is ERC1155 {
    constructor(string memory _uri) ERC1155(_uri) {}
}

contract TokenAssistantTest is Test {
    TokenAssistant assistant;

    ERC20Instance wrappedToken;
    ERC20Instance erc20_0;
    ERC20Instance erc20_1;
    ERC721Instance erc721_0;
    ERC721Instance erc721_1;
    ERC1155Instance erc1155_0;
    ERC1155Instance erc1155_1;

    address user_0;
    address user_1;
    address user_2;

    constructor() {
        wrappedToken = new ERC20Instance("Wrapped Token", "Wrapped Token", 18);
        erc20_0 = new ERC20Instance("erc20_0", "erc20_0", 8);
        erc20_1 = new ERC20Instance("erc20_1", "erc20_1", 6);
        erc721_0 = new ERC721Instance("erc721_0", "erc721_0");
        erc721_1 = new ERC721Instance("erc721_1", "erc721_1");
        erc1155_0 = new ERC1155Instance("");
        erc1155_1 = new ERC1155Instance("");

        assistant = new TokenAssistant(address(wrappedToken));

        user_0 = makeAddr("user_0");
        user_1 = makeAddr("user_1");
        user_2 = makeAddr("user_2");

        deal(user_0, 1e18);
        deal(user_1, 2e18);

        deal(address(wrappedToken), user_0, 1e18);
        deal(address(wrappedToken), user_1, 2e18);
        deal(address(erc20_0), user_0, 1e8);
        deal(address(erc20_0), user_1, 2e8);
        deal(address(erc20_1), user_0, 1e6);
        deal(address(erc20_1), user_1, 2e6);

        // dealERC721(address(erc721_0), user_0, 1);
        // dealERC721(address(erc721_0), user_1, 2);
        // dealERC721(address(erc721_1), user_0, 1);
        // dealERC721(address(erc721_1), user_1, 2);
    }

    function test_disperseNative() public {
        vm.startPrank(user_0);
        address payable[] memory recipients = Array.toDynamic([payable(user_1), payable(user_2)]);
        uint[] memory values = Array.toDynamic([uint(1), uint(2)]);
        assistant.disperseNative{value: 3}(recipients, values);
        vm.stopPrank();
        assertEq(user_1.balance, 2e18+1);
        assertEq(user_2.balance, 2);
    }

    function test_disperseNative_revert_NonMsgValue() public {
        vm.startPrank(user_0);
        address payable[] memory recipients = Array.toDynamic([payable(user_1), payable(user_2)]);
        uint[] memory values = Array.toDynamic([uint(1), uint(2)]);
        vm.expectRevert(TokenAssistant.NonMsgValue.selector);
        assistant.disperseNative(recipients, values);
        vm.stopPrank();
    }

    function test_disperseErc20() public {
        vm.startPrank(user_0);
        address[] memory recipients = Array.toDynamic([user_1, user_2]);
        uint[] memory values = Array.toDynamic([uint(1), uint(2)]);
        erc20_0.approve(address(assistant), 3);
        assistant.disperseErc20(address(erc20_0), recipients, values);
        vm.stopPrank();
        assertEq(erc20_0.balanceOf(user_0), 1e8-3);
        assertEq(erc20_0.balanceOf(user_1), 2e8+1);
    }
}