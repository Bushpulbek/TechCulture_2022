const hre = require("hardhat");

async function main() {
  // Get token
  const TokenValikhan = await hre.ethers.getContractFactory("ValikhanToken");
  // Deploy token with constructor
  const tokenValikhan = await TokenValikhan.deploy()
  // Wait to deploy
  await tokenValikhan.deployed()
  
  // Spoiler: 0x689Bd7aD23017D7521E334c9d7f79Ea6A974a979
  console.log("Token address", tokenValikhan.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
