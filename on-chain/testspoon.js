const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ConcaveNFT", function () {
    const colorsAddress = "0x9fdb31F8CE3cB8400C7cCb2299492F2A498330a4"
    let thecolors;

    it("Locates Original TheColors NFT", async () => {
        const TheColors = await ethers.getContractFactory("TheColors");
        thecolors = await TheColors.attach(colorsAddress);
    })
})
