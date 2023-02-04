// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const requireText = require('require-text');
const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

async function main() {

  const tokenAmount = "500";
  [owner, signer1] = await ethers.getSigners();

  // Setup Presale
  const presaleAddress = requireText("./sources/presaleAddress.txt", require);
  const presale = await ethers.getContractAt("contracts/Presale.sol:Presale", presaleAddress);

  // Calculate Proof
  const strAddresses = requireText("./sources/whitelist.txt", require);
  const addresses = strAddresses.split(/\r?\n/g);

  const leafNodes = addresses.map(addr => keccak256(addr));
  const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });

  const user = keccak256(owner.address);
  const hexProof = merkleTree.getHexProof(user);

  // Enter Private sale
  const parsedAmount = ethers.utils.parseEther(tokenAmount);
  await presale.connect(owner).enterPrivate(parsedAmount, hexProof);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
