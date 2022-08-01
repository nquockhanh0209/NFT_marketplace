
const { ethers, waffle} = require("hardhat");
//const { time } = require('openzeppelin-test-helpers');  
//const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
describe("NFT", function () {
  // async function deployContract() {
  //   const [owner, otherAccount] = await ethers.getSigners();
  //   const NFT = await ethers.getContractFactory("NFT");
  //   const nft = await NFT.deploy("name", "symbol");
  //   await nft.deployed();
  //   const COLLECTION = await ethers.getContractFactory("collection");
  //   const collection = await COLLECTION.deploy("name", "symbol");
  //   await collection.deployed();
    
    
  //   return { nft, collection, owner, otherAccount};
  // }
 
  it("create new collection", async function () {
    
    // const { nft, collection } = await loadFixture(
    //   deployContract
    // );
    const [owner, otherAccount, otherAccount1] = await ethers.getSigners();
    const NFT = await ethers.getContractFactory("NFT");
    const nft = await NFT.deploy("name", "symbol");
    await nft.deployed();

    const COLLECTION = await ethers.getContractFactory("collection");
    const collection = await COLLECTION.deploy("name", "symbol");
    await collection.deployed();

    const FACTORY = await ethers.getContractFactory("cloneFactory");
    const factory = await FACTORY.deploy();
    await factory.deployed();

    const NFT1155 = await ethers.getContractFactory("NFT_1155");
    const nft1155 = await NFT1155.deploy(" ");
    await nft1155.deployed();

    // await collection.createCollection("name");
    // console.log(await collection.showCollection(1));
    // await nft.functions.createNFT(owner.address, "123");
    // //console.log(await nft.functions.createNFT(owner.address, "123"));
    
    // await collection.storeCollection(1, await nft.callStatic.createNFT(owner.address, "123"));
    // // await nft.functions.createNFT(owner.address, "123")
    // // await collection.storeCollection(1, await nft.callStatic.createNFT(owner.address, "123"));
    // // await nft.functions.createNFT(owner.address, "123")
    // // await collection.storeCollection(1, await nft.callStatic.createNFT(owner.address, "123"));
    // // await nft.functions.createNFT(owner.address, "123")
    // // await collection.storeCollection(1, await nft.callStatic.createNFT(owner.address, "123"));

    // console.log(await collection.showCollectionNFT(1));
    const amount = await [10,10,10,10,10,10,10,10,10,10];
    const unique = await [1,1,1,1,1,1,1,1,1,1];
    await nft1155.createSeveral1155NFT(owner.address, " ", 10, amount,unique);
    console.log(await nft1155.NFTbalance([owner.address, owner.address], [2,3]));
    await nft1155.transferBatch1155NFT(owner.address, otherAccount.address, [2,3],[5,5])
    // console.log(await nft1155.NFTbalance([otherAccount.address],[2]));
    
    await nft1155.transferBatchfromOnetoMore(owner.address,[otherAccount.address, otherAccount1.address], [[2,3],[0,1]], [[5,5],[5,5]] );
    const boolean = await [true,true,true];
    const boolean1 = await [true, false, true];
    console.log(await nft1155.checkArray(boolean, boolean1));
  });
    
  


    
    
})
  