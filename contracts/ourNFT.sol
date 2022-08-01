// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./NFT_collection.sol";

contract NFT is ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => address) private NFTowners;
    mapping(uint256 => uint256) public NFTprice;
    //mapping(uint256 => mapping (uint256 => uint256)) collectionNFTs;
    uint256 public number;

    // struct NFT {
    //     string memory name;
    //     string memory tokenURI;
    //     uint256 tokenId;
    //     uint256 price;
    // }

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}

    //mint an NFT, set NFT URI
    //return NFT id
    function createNFT(address creator, string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newNFTid = _tokenIds.current();
        _mint(creator, newNFTid);
        _setTokenURI(newNFTid, tokenURI);
        NFTowners[newNFTid] = creator;

        return newNFTid;
    }

    //transfer a NFT
    function transferNFT(
        address from,
        address to,
        uint256 tokenId
    ) public {
        _transfer(from, to, tokenId);
    }

    //approve NFT
    function approveNFT(address to, uint256 tokenId) public {
        _approve(to, tokenId);
    }

    //return owner of NFT

    function NFTowner(uint256 tokenId) public view returns (address) {
        return ERC721.ownerOf(tokenId);
    }

    //show the owner NFTs
    function ownerNFT(address owner) public view returns (uint256[] memory) {
        uint256[] memory temp;
        for (uint256 i = 0; i < _tokenIds.current(); i++) {
            uint256 index = 0;
            if (NFTowners[i] == owner) {
                temp[index] = i;
                index++;
            }
        }
        return temp;
    }

    //set and get NFT price
    //set price for fixed situation
    //or highest price for auction

    function setNFTprice(uint256 price, uint256 tokenId) private {
        NFTprice[tokenId] = price;
    }

    function getNFTprice(uint256 tokenId) public view returns (uint256) {
        return NFTprice[tokenId];
    }
}
