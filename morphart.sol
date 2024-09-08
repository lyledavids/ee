// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ArtNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => string) private _tokenImages;

    constructor() ERC721("ArtNFT", "ART") {}

    function mintNFT(address recipient, string memory imageData) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _tokenImages[newItemId] = imageData;
        return newItemId;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        //require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory imageData = _tokenImages[tokenId];
        string memory json = Base64.encode(
            bytes(string(abi.encodePacked(
                '{"name": "ArtNFT #', 
                toString(tokenId), 
                '", "description": "On-chain Art NFT", "image": "', 
                imageData,
                '"}'
            )))
        );

        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}