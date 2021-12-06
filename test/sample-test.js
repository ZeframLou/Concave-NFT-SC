const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ConcaveNFT", function () {
  let ConcaveNFT
  const _name = "name"
  const _symbol = "symbol"
  const _initBaseURI = "_initBaseURI"
  const _initNotRevealedUri = "_initNotRevealedUri"

  it("ConcaveNFT should deploy", async function () {
    ConcaveNFT = await ethers.getContractFactory("ConcaveNFT");
    const concavenft = await ConcaveNFT.deploy(
      _name,
      _symbol,
      _initBaseURI,
      _initNotRevealedUri
    );
    console.log('concavenft deployed')
    // await greeter.deployed();
    //
    // expect(await greeter.greet()).to.equal("Hello, world!");
    //
    // const setGreetingTx = await greeter.setGreeting("Hola, mundo!");
    //
    // // wait until the transaction is mined
    // await setGreetingTx.wait();
    //
    // expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});
