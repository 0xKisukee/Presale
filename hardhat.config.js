require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {

  solidity: "0.8.17",

  networks: {

    localhost: {
      url: "http://localhost:8545",
    },

    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/pVoLxyNx_5wl77cX2iFw7s1_EioGnANT",
      accounts: ["2038513449f35cb67eefda892a8080fb324c462ea7ce12784cd2189d10b11b0c"]
    },

  },

  etherscan: {
    apiKey: "7JJITTNG6MBG78BFKZ8IY2SVHGIV2C38H6",
  }
};