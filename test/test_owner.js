const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");

describe("ConcaveNFT", function () {

  const _name = "name"
  const _symbol = "symbol"
  const _initBaseURI = "ipfs://QmXytj58vtcvm9SwwBPvJykApcsr9aeChX4BcRha2wc31i/"
  const _initNotRevealedUri = "ipfs://QmYJJDthYUGV57FQ57VCeXcCBnpWoGjxtHsWcDLEY1Bp19"
  const colorsOwner = "0xfA8F061675f46CB9e71308BDf3C1C15E35011AC2"
  const maxSupply = 4317;
  const maxMintAmount = 10;
  const price = ethers.utils.parseEther('0.03');

  let ConcaveNFT
  let deployer;
  let thirdParty;
  let concavenft;


  before(async function () {
      [deployer, thirdParty] = await ethers.getSigners();
    // Get the ContractFactory and Signers here.
    // console.log('before')
    ConcaveNFT = await ethers.getContractFactory("ConcaveNFT");
    concavenft = await ConcaveNFT.deploy(
        _name,
        _symbol,
        _initBaseURI,
        _initNotRevealedUri
    );
    // console.log(ConcaveNFT)
  });

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
    colorsOwnerSigner = await ethers.provider.getSigner(colorsOwner);
    // console.log(thecolors)
    // await thecolors.connect(colorsOwnerSigner).transferFrom(colorsOwner,deployer.address,0)
    await concavenft.unpause();
    await concavenft.connect(colorsOwnerSigner).mint(2)
    const bal = await concavenft.balanceOf(colorsOwner)
    console.log(bal)
  });





  // it("ConcaveNFT should mint", async function () {
  //   await concavenft.mint(1);
  // });

  // it("ConcaveNFT should get URI", async function () {
  //   let uri = await concavenft.tokenURI(1);
  //   await expect(
  //       concavenft.mint(1)
  //   ).to.be.revertedWith(`Public sale isn't active yet!`);
  // });


});
