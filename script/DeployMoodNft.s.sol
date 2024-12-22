// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {
        string memory happySvg = vm.readFile("images/dynamicNfts/happy.svg");
        string memory sadSvg = vm.readFile("images/dynamicNfts/sad.svg");

        string memory happySvgImageURI = svgToImgURI(happySvg);
        string memory sadSvgImageURI = svgToImgURI(sadSvg);

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(sadSvgImageURI, happySvgImageURI);
        vm.stopBroadcast();
        return moodNft;
    }

    function svgToImgURI(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}
