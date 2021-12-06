require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require('dotenv').config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
//     gasReporter: {
//     currency: 'USD',
//     gasPrice: 80,
//     gasPriceApi:'https://api.etherscan.io/api?module=proxy&action=eth_gasPrice'
// },
  networks: {
 /* rinkeby: {
    url: "https://eth-rinkeby.alchemyapi.io/v2/123abc123abc123abc123abc123abcde",
    accounts: [process.env.PRIVATE_KEY]
  },*/
  // hardhat: {
  //   chainId: 1337
  // },
  hardhat: {
    forking: {
      url: process.env.API_MAINNET,
      blockNumber: 13752124
    }
  }
},
  solidity: "0.8.4",
};
