const DaiToken = artifacts.require("DaiToken");
const DappToken = artifacts.require("DappToken");
const TokenFarm = artifacts.require("TokenFarm");

require("chai").use(require("chai-as-promised")).should();

contract("TokenFarm", ([owner, investor]) => {
  let daiToken, dappToken, tokenFarm;

  before(async () => {
    daiToken = await DaiToken.new();
    dappToken = await DappToken.new();
    tokenFarm = await TokenFarm.new(daiToken.address, dappToken.address);

    dappToken.transfer(tokenFarm.address, web3.utils.toWei("1000000", "ether"));

    daiToken.transfer(investor, web3.utils.toWei("100", "ether"), {
      from: owner,
    });
  });

  describe("Mock DAI deployment", () => {
    it("has a name", async () => {
      const name = await daiToken.name();
      assert.equal(name, "Mock DAI Token");
    });
  });

  describe("Dapp Token deployment", () => {
    it("has a name", async () => {
      const name = await dappToken.name();
      assert.equal(name, "DApp Token");
    });
  });

  describe("Token Farm deployment", () => {
    it("has a name", async () => {
      const name = await tokenFarm.name();
      assert.equal(name, "Dapp Token Farm");
    });

    it("contract has tokens", async () => {
      const balance = await dappToken.balanceOf(tokenFarm.address);
      assert.equal(balance.toString(), web3.utils.toWei("1000000", "ether"));
    });
  });

  describe("Farming Token", () => {
    it("reward investor for staking mDai token", async () => {
      let result;

      result = await daiToken.balanceOf(investor);
      assert(
        result.toString(),
        web3.utils.toWei("100", "ether"),
        "investor initial mDai balance must be correct",
      );

      await daiToken.approve(
        tokenFarm.address,
        web3.utils.toWei("100", "ether"),
        {
          from: investor,
        },
      );
      await tokenFarm.stakeDaiTokens(web3.utils.toWei("100", "ether"), {
        from: investor,
      });

      result = await daiToken.balanceOf(investor);
      assert(
        result,
        web3.utils.toWei("0", "ether"),
        "investor mDai balance after staking must be correct",
      );

      result = await tokenFarm.stakingBalance(investor);
      assert(
        result,
        web3.utils.toWei("100", "ether"),
        "investor Token Farm after staking must be correct",
      );

      result = await tokenFarm.isStaking(investor);
      assert(
        result,
        true,
        "investor staking status after staking must be correct",
      );
    });
  });
});
