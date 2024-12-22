// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    string public constant PUG =
        "http://bafybeie5ohuwtww5bvrxoumnsb7fxz5j2kg4paiv7ay3nxaaa5mvvspa5q.ipfs.localhost:8080/";
    address public constant USER = address(0x123);

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expected = "Dogie";
        string memory actual = basicNft.name();
        assertEq(expected, actual); // string comparison without keccak
    }

    function testSymbolIsCorrect() public view {
        string memory expected = "Dog";
        string memory actual = basicNft.symbol();
        assertEq( // string comparison with keccak
            keccak256(abi.encodePacked(expected)),
            keccak256(abi.encodePacked(actual))
        );
    }

    modifier asUser() {
        vm.prank(USER);
        _;
    }

    function testCanMintAndHaveABalance() public asUser {
        basicNft.mintNft(PUG);
        assertEq(basicNft.balanceOf(USER), 1);
        assertEq(PUG, basicNft.tokenURI(0));
    }
}
