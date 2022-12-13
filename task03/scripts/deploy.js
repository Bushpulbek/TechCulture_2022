const hre = require("hardhat");

async function main() {
  // Spoler: 0x8d1333bD5d28fF6c0706DB61043191d4bfFacde3
  const TokenValikhan = await hre.ethers.getContractFactory("VToken");
  const tokenValikhan = await TokenValikhan.deploy();
  await tokenValikhan.deployed();

  // Spoler: 0xd1125039DcDb644AebAbaa7f9592F590398d01A4
  const TokenStake = await hre.ethers.getContractFactory("stake");
  const tokenStake = await TokenStake.deploy(tokenValikhan.address);
  await tokenStake.deployed();

  console.log("VToken: ", tokenValikhan.address);
  console.log("stake: ", tokenStake.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
