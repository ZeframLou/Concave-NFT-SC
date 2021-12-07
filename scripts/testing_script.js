

const { expect } = require("chai");
const hre = require("hardhat");




async function main() {

const amountToMint = 1;
// fill with address given by hardhat on deploy 

const [owner] = await ethers.getSigners();

console.log("Testing contracts with the account:", owner.address);

const concaveAddress = '0x1eAE12E9f9360133Ff680253Dc29fb4918c862F1';

const Concave = await hre.ethers.getContractFactory("ConcaveNFT");


const concave = await Concave.attach(concaveAddress);

const unrevealedUri = "https://gateway.pinata.cloud/ipfs/QmYJJDthYUGV57FQ57VCeXcCBnpWoGjxtHsWcDLEY1Bp19";
const revealBaseUri = "https://gateway.pinata.cloud/ipfs/QmXytj58vtcvm9SwwBPvJykApcsr9aeChX4BcRha2wc31i/";


/*console.log ("Testing unpause");
await concave.unpause();*/

/*
console.log ("Minting one NFT");
await concave.mint(amountToMint);
console.log ("Mint succesfull");
*/

/*
console.log ("Updating unrevealed URI");
await concave.setNotRevealedURI(unrevealedUri);
console.log ("unrevealed URI updated");
console.log ("Token 0 URI " + await concave.tokenURI(0))
*/

/*
console.log ("Updating revealed URI");
await concave.setBaseURI(revealBaseUri);
console.log ("revealed URI updated");
console.log ("Token 0 URI " + await concave.tokenURI(0))
*/

/*
console.log ("Revealing tokens");
await concave.reveal();
console.log ("Tokens revealed");
*/

console.log ("Token 0 URI " + await concave.tokenURI(0))


}

main()
.then(() => process.exit(0))
.catch(error => {
  console.error(error);
  process.exit(1);
});

