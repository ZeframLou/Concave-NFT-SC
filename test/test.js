const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ConcaveNFT", function () {

  const _name = "name"
  const _symbol = "symbol"
  const _initBaseURI = "https://gateway.pinata.cloud/ipfs/QmXytj58vtcvm9SwwBPvJykApcsr9aeChX4BcRha2wc31i/"
  const _initNotRevealedUri = "ipfs://QmYJJDthYUGV57FQ57VCeXcCBnpWoGjxtHsWcDLEY1Bp19"

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



  // it("gets signers", async () => {
  //   [deployer, thirdParty] = await ethers.getSigners();
  // })

  describe("Deployment", () => {
      // it("ConcaveNFT should deploy", async function () {
      //   ConcaveNFT = await ethers.getContractFactory("ConcaveNFT");
      //   concavenft = await ConcaveNFT.deploy(
      //       _name,
      //       _symbol,
      //       _initBaseURI,
      //       _initNotRevealedUri
      //   );
      // });
      it("Owner of contract should be deployer",async () => {
          expect(await concavenft.owner()).to.equal(deployer.address)
      })
  })

  describe("Constants", () => {
      it(`Name should be ${_name}`, async () => {
        expect(await concavenft.name()).to.equal(_name)
      })
      it(`Name should be ${_name}`, async () => {
        expect(await concavenft.name()).to.equal(_name)
      })
      it(`Symbol should be ${_symbol}`, async () => {
        expect(await concavenft.symbol()).to.equal(_symbol)
      })
      it(`Base URI should be ${_initBaseURI}`, async () => {
        expect(await concavenft.baseURI()).to.equal(_initBaseURI)
      })
      it(`Unrevealed URI should be ${_initNotRevealedUri}`, async () => {
        expect(await concavenft.notRevealedUri()).to.equal(_initNotRevealedUri)
      })
      it(`Max Supply should be: ${maxSupply}`, async () => {
        expect(await concavenft.maxSupply()).to.equal(maxSupply)
      })
      it(`Price should be: ${price} wei`, async () => {
        expect(await concavenft.price()).to.equal(price)
      })
      it(`Contract should be paused at launch`, async () => {
        expect(await concavenft.paused()).to.equal(true)
      })
  })

  describe("Method Calls", () => {


      beforeEach(async function () {
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
      });

      describe("mint()",() => {
          it("Minting Should Fail with `Pausable: paused` when Paused", async function () {
            await expect(
                concavenft.mint(1)
            ).to.be.revertedWith(`Pausable: paused`);
          });
          it("Minting Should Not Fail with `Pausable: paused` when unpaused", async function () {
            await concavenft.unpause()
            await expect(
                concavenft.mint(1)
            ).not.to.be.revertedWith(`Pausable: paused`);
          });
          it(`Minting Should Fail with 'minting too many' if minting more than ${maxMintAmount}`, async function () {
            await concavenft.unpause()
            await expect(
                concavenft.mint(11)
            ).to.be.revertedWith(`minting too many`);
          });

        //   it(`If supply reaches ${maxSupply} - minting Should Fail with 'no enough supply'`, async function () {
        //     await concavenft.unpause()
        //     for (var i = 0; i < maxSupply; i++) {
        //         if (i > 200) {
        //             await concavenft.mint(1,{
        //                 value: price
        //             })
        //         } else {
        //             await concavenft.mint(1)
        //         }
        //     }
        //     let m = await concavenft.totalSupply();
        //     // console.log(m);
        //     expect(m).to.equal(maxSupply)
        //     await expect(
        //         concavenft.mint(1)
        //     ).to.be.revertedWith(`no enough supply`);
        // }).timeout(0);

        it(`If minting 0 - should revert with 'minting zero'`, async function () {
          await concavenft.unpause()
          await expect(
              concavenft.mint(0)
          ).to.be.revertedWith(`minting zero`);
        });
        it(`If minting 10 - transaction should succeed and totalSupply should be 10`, async function () {
          await concavenft.unpause()
          await concavenft.mint(10)
          await expect(
              await concavenft.totalSupply()
          ).to.equal(10);
        });
        it(`If minting 10 - transaction should succeed and balanceOf owner should be 10`, async function () {
          await concavenft.unpause()
          await concavenft.mint(10)
          await expect(
              await concavenft.balanceOf(deployer.address)
          ).to.equal(10);
        });
        // it(`The first 200 mints should be free mints`, async function () {
        //   await concavenft.unpause()
        //   for (var i = 0; i < 200; i++) {
        //       await concavenft.mint(1)
        //   }
        // });
        // it(`Mint #201 and later should fail with 'insufficient' if amount sent is less price`, async function () {
        //   await concavenft.unpause()
        //   for (var i = 0; i < 200; i++) {
        //       await concavenft.mint(1)
        //   }
        //   await expect(
        //       await concavenft.totalSupply()
        //   ).to.equal(200);
        //
        //   await expect(
        //       concavenft.mint(1)
        //   ).to.be.revertedWith(`insufficient funds`);
        // });
        it(`Mint #201 and later should fail with 'insufficient funds' if amount sent is less price*value`, async function () {
          await concavenft.unpause()
          for (var i = 0; i < 200; i++) {
              await concavenft.mint(1)
          }
          await expect(
              await concavenft.totalSupply()
          ).to.equal(200);

          await expect(
              concavenft.mint(2,{value: price})
          ).to.be.revertedWith(`insufficient funds`);
        });
        it(`Mint #201 and later should pass if amount sent is = price*value`, async function () {
          await concavenft.unpause()
          for (var i = 0; i < 200; i++) {
              await concavenft.mint(1)
          }
          await expect(
              await concavenft.totalSupply()
          ).to.equal(200);

          await concavenft.mint(2,{value: ethers.utils.parseEther((0.03*2).toString())})
        });

      })



      describe("reveal()",() => {
          beforeEach(async function () {
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
          });
          it(`Third Party must not be able to call reveal()`, async () => {
              await expect(
                  concavenft.connect(thirdParty).reveal()
              ).to.be.revertedWith(`Ownable: caller is not the owner'`);
          })
          it(`Owner must be able to call reveal()`, async () => {
              await concavenft.reveal()
          })
          it(`token uri before reveal should be ${_initNotRevealedUri}`, async () => {
              await concavenft.unpause()
              await concavenft.mint(10)
              expect(await concavenft.tokenURI(0)).to.equal(_initNotRevealedUri)
          })
          it(`token uri after reveal for token 0 should be ${_initBaseURI}0.json`, async () => {
              await concavenft.unpause()
              await concavenft.mint(10)
              await concavenft.reveal()
              expect(await concavenft.tokenURI(0)).to.equal(`${_initBaseURI}0.json`)
          })
      })
  })








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
