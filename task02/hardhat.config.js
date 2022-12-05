require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.7",
  networks: {
    testnet: {
      url: "https://bsctestapi.terminet.io/rpc",
      chainId: 97,
      accounts: {
        mnemonic: "lady can jelly alarm horror copper dice asset supply aerobic card grace",
      },
    },
  },
};
