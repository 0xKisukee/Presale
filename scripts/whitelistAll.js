// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const requireText = require('require-text');

async function main() {

  const strAddresses = requireText("./sources/whitelist.txt", require);
  const addresses = strAddresses.split(/\r?\n/g);

  // Setup Presale
  const presaleAddress = requireText("./sources/presaleAddress.txt", require);
  const presale = await ethers.getContractAt("contracts/Presale.sol:Presale", presaleAddress);

  // Whitelist users
  for (let i = 0; i < addresses.length; i++) {
    await presale.whitelist(addresses[i]);
    console.log("Whitelisted: " + addresses[i]);
  }

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
