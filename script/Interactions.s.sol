// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {DeployBasicNft} from "./DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNft is Script {
    string public constant PUG =
        "http://bafybeie5ohuwtww5bvrxoumnsb7fxz5j2kg4paiv7ay3nxaaa5mvvspa5q.ipfs.localhost:8080/";

    DeployBasicNft public deployer;
    BasicNft public basicNft;

    function run() external {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();

        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNft",
            block.chainid
        );

        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(PUG);
        vm.stopBroadcast();
    }
}
