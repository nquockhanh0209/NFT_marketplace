async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const NFT = await ethers.getContractFactory("NFT");
  const collection = await ethers.getContractFactory("collection");
  const nft = await NFT.deploy("name","symbol");
  //const col = await collection.deploy()

  console.log("NFT address:", nft.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });