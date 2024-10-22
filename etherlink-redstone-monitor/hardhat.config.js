require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");
const { vars } = require("hardhat/config");

module.exports = {
  solidity: {
    version: "0.8.27",
    settings: {
      evmVersion: "shanghai",
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    etherlink_ghostnet: {
      url: `https://node.ghostnet.etherlink.com`,
      accounts: [vars.get("PRIVATE_KEY")],
    },
    etherlink_mainnet: {
      url: `https://node.mainnet.etherlink.com`,
      accounts: [vars.get("PRIVATE_KEY")],
    },
  },
  etherscan: {
    apiKey: {
      // Is not required by blockscout. Can be any non-empty string
      'etherlink_ghostnet': "abc",
      'etherlink_mainnet' : "def"
    },
    customChains: [
      {
        network: "etherlink_ghostnet",
        chainId: 128123,
        urls: {
          apiURL: "https://testnet.explorer.etherlink.com/api",
          browserURL: "https://testnet.explorer.etherlink.com/",
        }
      },
      {
        network: "etherlink_mainnet",
        chainId: 42793,
        urls: {
          apiURL: "https://explorer.etherlink.com/api",
          browserURL: "https://explorer.etherlink.com/",
        }
      }
    ]
  },
  sourcify: {
    enabled: false
  }
};
