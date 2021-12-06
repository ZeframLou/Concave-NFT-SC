const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ConcaveNFT", function () {
  let ConcaveNFT
  const _name = "name"
  const _symbol = "symbol"
  const _initBaseURI = "_initBaseURI"
  const _initNotRevealedUri = "_initNotRevealedUri"

  const colorsOwner = "0xfA8F061675f46CB9e71308BDf3C1C15E35011AC2"
  const colorsAddress = "0x9fdb31F8CE3cB8400C7cCb2299492F2A498330a4"

  let thecolors;
  let deployer



  it("gets signers", async () => {
    const [d, _] = await ethers.getSigners();
    deployer = d
  })

  it("Locates Original TheColors NFT", async () => {
    const TheColors = await ethers.getContractFactory("TheColors");
    thecolors = await TheColors.attach(colorsAddress);
  })

  it("Total Supply of The Original Colors NFT = 4317", async () => {
    const totalSupply = await thecolors.totalSupply()
    // console.log({totalSupply})
    expect(totalSupply).to.equal(4317);
  })

  it("Impersonator is owner of token 0", async () => {
    const oo = await thecolors.ownerOf(0)
    // console.log({totalSupply})
    expect(oo).to.equal(colorsOwner);
  })

  it("Impersonates Account", async () => {
    // const admin =
    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [colorsOwner],
    });
    await network.provider.send("hardhat_setBalance", [
      colorsOwner,
      ethers.utils.parseEther('10.0').toHexString().replace("0x0", "0x"),
    ]);
    const signer = await ethers.provider.getSigner(colorsOwner);
    // console.log(thecolors)
    await thecolors.connect(signer).transferFrom(colorsOwner,deployer.address,0)
  });

  it("ConcaveNFT should deploy", async function () {
    ConcaveNFT = await ethers.getContractFactory("ConcaveNFT");
    const concavenft = await ConcaveNFT.deploy(
      _name,
      _symbol,
      _initBaseURI,
      _initNotRevealedUri
    );
    // console.log('concavenft deployed')
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
