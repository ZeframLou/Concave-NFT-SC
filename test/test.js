const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ConcaveNFT", function () {
  let ConcaveNFT
  const _name = "name"
  const _symbol = "symbol"
  const _initBaseURI = "https://gateway.pinata.cloud/ipfs/QmXytj58vtcvm9SwwBPvJykApcsr9aeChX4BcRha2wc31i/"
  const _initNotRevealedUri = "_initNotRevealedUri"

  const colorsOwner = "0xfA8F061675f46CB9e71308BDf3C1C15E35011AC2"
  const colorsAddress = "0x9fdb31F8CE3cB8400C7cCb2299492F2A498330a4"

  let thecolors;
  let deployer;
  let concavenft;
  let colorsOwnerSigner;



  it("gets signers", async () => {
    const [d, _] = await ethers.getSigners();
    deployer = d
  })


  it("ConcaveNFT should deploy", async function () {
    ConcaveNFT = await ethers.getContractFactory("ConcaveNFT");
    concavenft = await ConcaveNFT.deploy(
        _name,
        _symbol,
        _initBaseURI,
        _initNotRevealedUri
    );

  });

  it("ConcaveNFT should mint", async function () {
    await concavenft.mint(1);
  });

  it("ConcaveNFT should get URI", async function () {
    let uri = await concavenft.tokenURI(0);
    console.log('uri')
    console.log(uri)
  });


});
