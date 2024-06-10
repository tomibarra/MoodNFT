// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721
{
    //Errores
    error MoodNtf__CantFlipIfNotOwner();





    //Declaracion y definicion
    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum Mood 
    {
        HAPPY,
        SAD
        
    }

    mapping (uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory sadSvg, string memory happySvg) ERC721("Mood nft","MN")
    {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvg;
        s_happySvgImageUri = happySvg;
        
    }

    function mintNft() public
    {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public
    {
       //Si no es el dueño revierte
       if(_getApproved(tokenId) != msg.sender && _ownerOf(tokenId) != msg.sender) 
       {
            revert MoodNtf__CantFlipIfNotOwner();
       }

        //Cambiar el estado del token
       if(s_tokenIdToMood[tokenId] == Mood.HAPPY)
       {
        s_tokenIdToMood[tokenId] = Mood.SAD;
       }
       else
       {
        s_tokenIdToMood[tokenId] = Mood.HAPPY;
       }
    }

    function _baseURI() internal pure override returns(string memory)
    {
        return "data:application/json; base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns(string memory)
    {
        string memory imageURI;
        if(s_tokenIdToMood[tokenId] == Mood.HAPPY)
        {
            imageURI= s_happySvgImageUri;
        }
        else 
        {
           imageURI = s_sadSvgImageUri; 
        }

        return string(abi.encodePacked(_baseURI(), Base64.encode(abi.encodePacked('{"name":"', name(),  '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ', '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"', imageURI ,'"}'))));
    }
}







