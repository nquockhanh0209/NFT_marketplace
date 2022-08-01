require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-web3");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-ganache");
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "localhost",
  networks: {
    hardhat: {
    },
    localhost: {
      url: "http://127.0.0.1:7545",
      networkId: 5777
    }
  },
  solidity: {
    version: "0.8.9"
   
  },
  

};
