// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const requireText = require('require-text');

async function main() {

  const Token = await ethers.getContractFactory("Token");
  const token = await Token.deploy();
  await token.deployed();
  console.log("Token contract deployed at: " + token.address);

  const USDC = await ethers.getContractFactory("USDC");
  const usdc = await USDC.deploy();
  await usdc.deployed();
  console.log("USDC contract deployed at: " + usdc.address);

  const Presale = await ethers.getContractFactory("Presale");
  const presale = await Presale.deploy(11, 10, 1000, token.address, usdc.address);
  await presale.deployed();
  console.log("Presale contract deployed at: " + presale.address);

  // After deployments, you need to send tokens to the Presale contract.

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
