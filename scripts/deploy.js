// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const requireText = require('require-text');

async function main() {

  // Set these variables before deployement
  const publicPrice = 11;
  const privatePrice = 10;
  const maxAlloc = 1000;
  const tokenAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
  const stableAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";

  // Presale deployment
  const Presale = await ethers.getContractFactory("Presale");
  const presale = await Presale.deploy(publicPrice, privatePrice, maxAlloc, tokenAddress, stableAddress);
  await presale.deployed();
  console.log("Presale contract deployed at: " + presale.address);

  // After deployment, you need to send enough tokens to the Presale contract,
  // or users won't be able to claim their allocation.

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
