// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    // errors
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;
    string private s_sadSvgImageURI;
    string private s_happySvgImageURI;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory sadSvgImageURI,
        string memory happySvgImageURI
    ) ERC721("MoodNFT", "MOODn") {
        s_tokenCounter = 0;
        s_sadSvgImageURI = sadSvgImageURI;
        s_happySvgImageURI = happySvgImageURI;
        // s_tokenIdToMood[0] = Mood.HAPPY;
    }

    function flipMood(uint256 tokenId) public {
        if (!_isAuthorized(msg.sender, msg.sender, tokenId)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageURI;
        } else {
            imageURI = s_sadSvgImageURI;
        }

        string memory tokenMetadata = Base64.encode(
            bytes(
                abi.encodePacked(
                    '{"name":"',
                    name(),
                    '", "description": "An nft", "attributes": [{ "trait_type": "Mood", "value": 100}], "image": "',
                    imageURI,
                    '"}'
                )
            )
        );

        return string(abi.encodePacked(_baseURI(), tokenMetadata));
    }
}
