
const { ethers, waffle} = require("hardhat");
//const { time } = require('openzeppelin-test-helpers');  
//const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
describe("NFT", function () {
  
      
    
   
 
  describe("test", () =>{
    let owner
    let ownerAddress
    let otherAccount 
    let otherAccount1
    let nft
    let collection
    let factory
    let nft1155
    let nftAddress 
    before(async ()=>{
    [owner, otherAccount, otherAccount1] = await ethers.getSigners();
    ownerAddress = owner.address;  
    const NFT = await ethers.getContractFactory("NFT");
    nft = await NFT.deploy("name", "symbol");
    await nft.deployed();
    nftAddress = nft.address;

    const COLLECTION = await ethers.getContractFactory("collection");
    collection = await COLLECTION.deploy("name", "symbol");
    await collection.deployed();

    const FACTORY = await ethers.getContractFactory("cloneFactory");
    factory = await FACTORY.deploy();
    await factory.deployed();

    const NFT1155 = await ethers.getContractFactory("NFT_1155");
    nft1155 = await NFT1155.deploy("");
    await nft1155.deployed();
   })
  
    
   const types = {
    types: {
      EIP712Domain: [
        { name: "name", type: "string" },
        { name: "version", type: "string" },
        { name: "chainId", type: "uint256" },
        { name: "verifyingContract", type: "address" },
      ],
      permit: [
        { name: "holder", type: "address" },
        { name: "acceptance", type: "address" },
        { name: "nonce", type: "uint" },
        { name: "deadline", type: "uint" },
        { name: "isPermitted", type: "bool"}
      ]
    },
    //make sure to replace verifyingContract with address of deployed contract
    primaryType: "permit",
    domain: {
      name: "permission",
      version: "1",
      chainId: 31337,
      verifyingContract: nftAddress,
    },
    message: {
      holder: ownerAddress,
      acceptance: nftAddress,
      nonce: 1,
      deadline: 100000000000,
      isPermitted: true
    },
  };

    it("create new collection", async function () {

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
   it("test transfer permit", async function () {
      // let signature;
      // signature = await owner._signTypedData(
      //   {
      //     name: "withdrawal",
      //     version: "1",
      //     chainId: 31337,
      //     verifyingContract: nft.address,
      //   },
      //   {
      //     permit: [
      //       { name: "holder", type: "address" },
      //       { name: "acceptance", type: "address" },
      //       { name: "nonce", type: "uint" },
      //       { name: "deadline", type: "uint" },
      //       { name: "isPermitted", type: "bool"}
      //     ]
      //   },
      //   {
      //       holder: owner.address,
      //       acceptance: nft.address,
      //       nonce: 1,
      //       deadline: 100000000000,
      //       isPermitted: true
      //   });
      let signature = await owner._signTypedData(
    {
      name:"withdrawal",
      version:"1",
      chainId: 31337,
      verifyingContract: nft.address
    },
    {
       permit:[
          {name:"holder",type:"address"},
          {name:"taker",type:"address"},
          {name:"nonce",type:"uint"},
          {name:"deadline",type:"uint"},
          {name:"isPermitted",type:"bool"}
        ]
    },
    {
      holder: owner.address,
      taker: nft.address,
      nonce: 1,
      deadline: 100000000000,
      isPermitted: true
    }
  );
      signature = signature.substring(2);
      const r = "0x" + signature.substring(0, 64);
      const s = "0x" + signature.substring(64, 128);
      const v = parseInt(signature.substring(128, 130), 16);

      console.log("r:", r);
      console.log("s:", s);
      console.log("v:", v);
      console.log(owner.address);
      await nft.createNFT(owner.address, "123");
      // await nft.permit(
      //   owner.address, 
      //   nft.address, 
      //   1, 
      //   100000000000,
      //   true, 
      //   v, 
      //   r, 
      //   s );
      await nft.transferWithPermission(
        owner.address, 
        otherAccount.address, 
        1, 
        1,
        100000000000,
        true, 
        v, 
        r, 
        s );
        let anotherOwner = await nft.NFTowner(1);
        console.log(otherAccount.address == anotherOwner);
        
  })
  it("test transfer permit", async function () {
     
      let signature = await owner._signTypedData(
    {
      name:"withdrawal",
      version:"1",
      chainId: 31337,
      verifyingContract: nft.address
    },
    {
       permit:[
          {name:"holder",type:"address"},
          {name:"taker",type:"address"},
          {name:"nonce",type:"uint"},
          {name:"deadline",type:"uint"},
          {name:"isPermitted",type:"bool"}
        ]
    },
    {
      holder: owner.address,
      taker: nft.address,
      nonce: 1,
      deadline: 100000000000,
      isPermitted: true
    }
  );
      signature = signature.substring(2);
      const r = "0x" + signature.substring(0, 64);
      const s = "0x" + signature.substring(64, 128);
      const v = parseInt(signature.substring(128, 130), 16);

      console.log("r:", r);
      console.log("s:", s);
      console.log("v:", v);
      console.log(owner.address);
      await nft.createNFT(owner.address, "123");
      await collection.setNFTcontractAddress(nft.address);
      console.log(await collection.nftAddress());
      console.log(nft.address);
      await collection.transferFromCollectionWithSig(
        owner.address, 
        otherAccount.address, 
        1, 
        1,
        100000000000,
        true, 
        v, 
        r, 
        s );
  }
  );
  })
    
  


    
    
})
  