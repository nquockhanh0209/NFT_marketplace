// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

//import "./NFT_collection.sol";
contract NFT_1155 is ERC1155, ERC1155URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => mapping(address => uint256)) private owner_balances;
    mapping(uint256 => uint256) public tokenSupply;
    mapping(uint256 => bool) private uniqueNFT;
    constructor(string memory NFT_URI) ERC1155(NFT_URI) {}

    //mint NFTs, set NFT URI
    //return NFT id

    
    function createSeveral1155NFT(
        address creator,
        string memory tokenURI,
        uint256 idsAmount,
        uint256[] memory amount,
        bool[] memory unique
    ) public {
        //the number of ids must equal to amount length
        require(idsAmount == amount.length, "1234");

        uint256[] memory newIdsArray = new uint256[](idsAmount);

        for (uint i = 0; i < idsAmount; i++) {
            newIdsArray[i] = _tokenIds.current();
            _tokenIds.increment();
        }

        _mintBatch(creator, newIdsArray, amount, "");
        for (uint i = 0; i < idsAmount; i++) {
            _setURI(newIdsArray[i], tokenURI);
            uniqueNFT[newIdsArray[i]] = unique[i];
            owner_balances[newIdsArray[i]][creator] = amount[i];
        }
        
    }
    function checkUnique(uint256[] memory Ids) public view returns(bool[] memory) {
        bool[] memory temp = new bool[](Ids.length);
        for(uint i = 0; i < temp.length; i++) {
            temp[i] = uniqueNFT[Ids[i]];
        }
        return temp;
    }
    function checkArray(bool[] memory array1, bool[] memory array2 ) public pure returns(bool) {
        require( array1.length == array2.length);
        for(uint i = 0; i < array1.length; i++) {
            if(array1[i] != array2[i]){
                return false;
                
            }
        }
        return true;
    }
    function mintMore(
        address owner, 
        uint256[] memory Ids, 
        uint256[] memory amount
    ) public {
        
        bool[] memory allTrue = new bool[](Ids.length);
        bool[] memory checking = checkUnique(Ids);
        for(uint i = 0; i < Ids.length; i++) {
            allTrue[i] = true;
        }
        require(checkArray(allTrue,checking),"ids not mintable");
        _mintBatch(owner, Ids, amount, "");
        
    }
    function totalSupply(uint256 NFTid) public view returns (uint256) {
        return tokenSupply[NFTid];
    }


    function transferBatch1155NFT(
        address from,
        address to,
        uint256[] memory Ids,
        uint256[] memory amount
    ) public {
        _safeBatchTransferFrom(from, to, Ids, amount, "");
    }

    //enhance transfer from 0ne to more
    function transferBatchfromOnetoMore(
        address from, 
        address[] memory to, 
        uint256[][] memory Ids, 
        uint256[][] memory amount
    ) public {
        require(to.length == Ids.length,"address and Ids not match");
        
        for(uint i = 0; i < to.length; i++) {
            _safeBatchTransferFrom(from, to[i], Ids[i], amount[i], "");
        }
    }
    function approveAll1155NFT(
        address owner,
        address operator,
        bool approved
    ) public {
        _setApprovalForAll(owner, operator, approved);
    }

    

    function NFTbalance(address[] memory account, uint256[] memory Ids)
        public
        view
        returns (uint256[] memory)
    {
        return balanceOfBatch(account, Ids);
    }
}
