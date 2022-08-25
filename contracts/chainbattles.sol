//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


//Deployed at 0x40c97d3C64f40DF8ade8A51479401ba277fF7aAa
contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => uint256) public tokenIdtoLevels;
    mapping(uint256 => uint256) public tokenIdtoSpeed;
    mapping(uint256 => uint256) public tokenIdtoStrength;
    mapping(uint256 => uint256) public tokenIdtoLife;

    struct NftChange {
        uint256 levels;
        uint256 speed;
        uint256 strength;
        uint256 life;

    }

    NftChange nftChange;

    constructor() ERC721("Chain Battles", "CBTLS") {

    }

    function generateCharacter(uint256 tokenId) public returns (string memory){
        setLevels(tokenId);
        bytes memory svg = abi.encodePacked(
            '<svg xmlns = "http://www.w3.org/2000/svg" preserveAspectRatio = "xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base {fill: white; font-family: serif; font-size: 14px; } </style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Warrior", '</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(), '</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(), '</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(), '</text>',
            '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLife(), '</text>',

            '</svg>'
        );

        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )
        );
    }

    //Set values
    function setLevels(uint256 tokenId) public {
        nftChange = NftChange(tokenIdtoLevels[tokenId], tokenIdtoSpeed[tokenId], tokenIdtoStrength[tokenId], tokenIdtoLife[tokenId]);
    }
    //Get values
    function getLevels() public view returns(string memory) {
        return nftChange.levels.toString();
    }
    function getSpeed() public view returns(string memory) {
        return nftChange.speed.toString();
    }
    function getStrength() public view returns(string memory) {
        return nftChange.strength.toString();
    }
    function getLife() public view returns(string memory) {
        return nftChange.life.toString();
    }


    function getTokenURI(uint256 tokenId) public returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name":"Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
                '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }
    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdtoLevels[newItemId] = 0;
        tokenIdtoSpeed[newItemId] = 100;
        tokenIdtoStrength[newItemId] = 40;
        tokenIdtoLife[newItemId] = 3;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
        //declare current attributes
        uint256 currentLevel = tokenIdtoLevels[tokenId];
        uint256 currentSpeed = tokenIdtoSpeed[tokenId];
        uint256 currentStrength = tokenIdtoStrength[tokenId];
        uint256 currentLife = tokenIdtoLife[tokenId];
        //add updates
        tokenIdtoLevels[tokenId] = currentLevel + 1;
        tokenIdtoSpeed[tokenId] = currentSpeed + 100;
        tokenIdtoStrength[tokenId] = currentStrength + 40;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
