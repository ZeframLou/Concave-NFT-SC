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
  let deployer;
  let concavenft;
  let colorsOwnerSigner;



  it("gets signers", async () => {
    const [d, _] = await ethers.getSigners();
    deployer = d
  })

  it("Locates Original TheColors NFT", async () => {
    const TheColors = await ethers.getContractFactory("TheColors");
    thecolors = await TheColors.attach(colorsAddress);
  })

  // it("getColorsOwnedByUser",async () => {
  //   const TheSpirals = await ethers.getContractFactory("TheSpirals");
  //   const thespirals = await TheSpirals.attach('0x9c3e5a4689D8A53886C2476f71e079Df6fBA4FC6');
  //   let m = await thespirals.getTokenSVG(0);
  //   console.log(m)
  //   m = await thespirals.getColorsOwnedByUser(colorsOwner)
  //   console.log(m)
  // }).timeout(0);

  it("Total Supply of The Original Colors NFT = 4317", async () => {
    const totalSupply = await thecolors.totalSupply()
    // console.log({totalSupply})
    expect(totalSupply).to.equal(4317);
  })

  it("Account to impersonate is owner of token 0", async () => {
    const oo = await thecolors.ownerOf(0)
    // console.log({totalSupply})
    expect(oo).to.equal(colorsOwner);
  })
  it("Account to impersonate is owner of token 1", async () => {
    const oo = await thecolors.ownerOf(1)
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
    colorsOwnerSigner = await ethers.provider.getSigner(colorsOwner);
    // console.log(thecolors)
    await thecolors.connect(colorsOwnerSigner).transferFrom(colorsOwner,deployer.address,0)
  });

  it("ConcaveNFT should deploy", async function () {
    ConcaveNFT = await ethers.getContractFactory("ConcaveNFT");
    concavenft = await ConcaveNFT.deploy(
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

  it("should not be able to mint [ mint() ]", async () => {
    await expect(
        concavenft.mint(1)
    ).to.be.revertedWith(`Public sale isn't active yet!`);
  })

  // it("should return colors owned by user (getColorsOwnedByUser)", async () => {
  //   // this.timeout(100000);
  //   let m = await concavenft.getColorsOwnedByUser(colorsOwner);
  //   // console.log(m)
  //   expect(m[0]).to.equal("1");
  //   // done();
  // }).timeout(0);


  it("should not be able to mint [ mint() ]", async () => {
    await concavenft.connect(colorsOwnerSigner)._presaleSingleMint(51)
  })


});
