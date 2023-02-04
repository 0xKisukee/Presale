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

  const strAddresses = requireText("./sources/whitelist.txt", require);
  const addresses = strAddresses.split(/\r?\n/g);

  const leafNodes = addresses.map(addr => keccak256(addr));
  const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });

  const user = keccak256("0x1Ffcf3d940Adf60CFDE398E193c7Dd7b75E2c736");
  const hexProof = merkleTree.getHexProof(user);
  console.log(hexProof);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
