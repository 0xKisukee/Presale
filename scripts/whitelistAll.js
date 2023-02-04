// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const requireText = require('require-text');

async function main() {

  // Setup Presale
  const presaleAddress = requireText("./sources/presaleAddress.txt", require);
  const presale = await ethers.getContractAt("contracts/Presale.sol:Presale", presaleAddress);

  console.log(await presale.whitelisted("0xa513e6e4b8f2a923d98304ec87f64353c4d5c853"));
  await presale.whitelist("0xa513e6e4b8f2a923d98304ec87f64353c4d5c853");
  console.log(await presale.whitelisted("0xa513e6e4b8f2a923d98304ec87f64353c4d5c853"));

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
