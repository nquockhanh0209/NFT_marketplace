// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./NFT_collection.sol";
import "@nomiclabs/buidler/console.sol";

contract NFT is ERC721, ERC721URIStorage {
    
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => address) private NFTowners;
    mapping(uint256 => uint256) private NFTprice;
    //mapping(uint256 => mapping (uint256 => uint256)) collectionNFTs;
    uint256 public number;
    mapping(address => uint256) nonces;
    mapping(address => mapping(address => uint)) approval;

    // struct NFT {
    //     string memory name;
    //     string memory tokenURI;
    //     uint256 tokenId;
    //     uint256 price;
    // }

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}

    function transferWithPermission(
        address from,
        address to,
        uint256 tokenId,
        uint256 nonce,
        uint256 deadline,
        bool isPermitted,
        uint256 v,
        bytes32 r,
        bytes32 s
    ) public {
        permit(from, address(this), nonce, deadline, isPermitted, v, r, s);
        require(approval[from][address(this)] == type(uint).max);
        _transfer(from, to, tokenId);
    }

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
        for (uint i = 0; i < _tokenIds.current(); i++) {
            uint index = 0;
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

    function permit(
        address holder,
        address taker,
        uint256 nonce,
        uint256 deadline,
        bool isPermitted,
        uint256 v,
        bytes32 r,
        bytes32 s
    ) public {
        bytes32 DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes("withdrawal")),
                keccak256(bytes("1")),
                31337,
                address(this)
            )
        );

        // bytes32 PERMIT_TYPEHASH = keccak256(
        //     "permit(address holder, address acceptance, uint256 nonce, uint256 deadline, bool isPermitted)"
        // );

        // bytes32 structHash = keccak256(
        //     abi.encode(
        //         keccak256("permit(address holder, address acceptance, uint nonce, uint deadline, bool isPermitted)"),
        //         holder,
        //         acceptance,
        //         nonce,
        //         deadline,
        //         isPermitted
        //     )
        // );
        bytes32 hashStruct = keccak256(
      abi.encode(
          keccak256("permit(address holder,address taker,uint nonce,uint deadline,bool isPermitted)"),
          holder,
          taker,
          nonce,
          deadline,
          isPermitted
        )
    );
        bytes32 EIP721hash = keccak256(
            abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hashStruct)
        );
       
        require(holder != address(0), "invalid holder");
        require(holder == ecrecover(EIP721hash, uint8(v), r, s), "invalid owner");
        require(deadline == 0 || deadline >= block.timestamp, "permit expired");
        nonces[holder]++;
        uint check = isPermitted ? type(uint).max : 0;
        approval[holder][taker] = check;
    }
    
    
}
