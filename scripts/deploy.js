// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  
  const [deployer] = await ethers.getSigners();
  const unrevealedUri = "https://gateway.pinata.cloud/ipfs/QmYJJDthYUGV57FQ57VCeXcCBnpWoGjxtHsWcDLEY1Bp19";
  const revealBaseUri = "https://gateway.pinata.cloud/ipfs/QmXytj58vtcvm9SwwBPvJykApcsr9aeChX4BcRha2wc31i/";

  console.log("Deploying contracts with the account:", deployer.address);
  // We get the contract to deploy
  const Concave = await hre.ethers.getContractFactory("ConcaveNFT");
  const concave = await Concave.deploy("CVSpoons","CVS",revealBaseUri,unrevealedUri);


  await concave.deployed();

  console.log("ConcaveNFT Spoons deployed to:", concave.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
