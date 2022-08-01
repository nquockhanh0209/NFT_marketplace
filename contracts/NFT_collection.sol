// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "./ourNFT.sol";

contract collection {
    string private _name;
    string private _symbol;
    using Counters for Counters.Counter;
    Counters.Counter private _collectionIds;
    struct COLLECTION {
        string collectionName;
        uint256 collectionId;
        uint256[] NFTsId;
        address payable collectionOwner;
    }

    mapping(uint256 => bool) public checkCollection;
    mapping(uint256 => COLLECTION) public allCollection;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    //COLLECTION[] public allCollection;

    function createCollection(string memory name) public {
        COLLECTION memory newCollection;
        _collectionIds.increment();
        uint256 newCollectionId = _collectionIds.current();
        allCollection[newCollectionId] = newCollection;
        //check collection available
        checkCollection[newCollectionId] = true;
        //create new collection
        allCollection[newCollectionId].collectionName = name;
        allCollection[newCollectionId].collectionId = newCollectionId;
        uint256[] memory empty;
        allCollection[newCollectionId].NFTsId = empty;
        allCollection[newCollectionId].collectionOwner = payable(msg.sender);
        //return allCollection[newCollectionId].collectionName;
    }

    function showCollection(uint256 myCollectionId)
        public
        view
        returns (
            string memory,
            uint256,
            uint256[] memory,
            address payable
        )
    {
        return (
            allCollection[myCollectionId].collectionName,
            allCollection[myCollectionId].collectionId,
            allCollection[myCollectionId].NFTsId,
            allCollection[myCollectionId].collectionOwner
        );
    }

    function storeCollection(uint256 myCollectionId, uint256 newtokenId)
        public
    {
        allCollection[myCollectionId].NFTsId.push(newtokenId);
    }

    function showCollectionNFT(uint256 myCollectionId)
        external
        view
        returns (uint256[] memory)
    {
        return allCollection[myCollectionId].NFTsId;
    }
}
