

const { expect } = require("chai");
const { ethers } = require("hardhat");




async function main() {

// fill with address given by hardhat on deploy 

const concaveAddress = '0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0';

const Concave = await hre.ethers.getContractFactory("ConcaveNFT");


const concave = await Concave.attach(concaveAddress);

// await theSpoons.sampleFunction();


}

main()
.then(() => process.exit(0))
.catch(error => {
  console.error(error);
  process.exit(1);
});

