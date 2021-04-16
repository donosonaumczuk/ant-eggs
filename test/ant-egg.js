const { expect } = require("chai");

describe("AntEgg contract", function () {

  let AntEgg;
  let antEgg;
  let ant;

  beforeEach(async function () {

    AntEgg = await ethers.getContractFactory("AntEgg");
    const [ant] = await ethers.getSigners();
    antEgg = await AntEgg.deploy(ant.address);
  });

  describe("Undivisibility", function () {

    it("Should be undivisible token with zero decimals", async function () {
      expect(await antEgg.decimals()).to.equal(0);
    });
  });
});