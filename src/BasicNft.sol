// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.18 ;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenCounter;
    //Mapea el id del token a la URI
    mapping (uint256 => string) private s_tokenIdToUri;



    constructor() ERC721 ("Dogie", "DOG") 
    {
       s_tokenCounter = 0; 
    }

    //Estudiar mas esta funcion, investigar significado de "mint"
    function mintNft(string memory tokenUri) public 
    {
       s_tokenIdToUri[s_tokenCounter] = tokenUri;
       _safeMint(msg.sender,s_tokenCounter);
        s_tokenCounter++;
    }


    function tokenURI(uint256 tokenId) public view override returns (string memory) 
    {
        return s_tokenIdToUri[tokenId];
    }


    
}
