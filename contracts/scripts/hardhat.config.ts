import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";

/**
 * ENV:
 * PRIVATE_KEY=0x...
 * SOMNIA_MAINNET_RPC=https://...
 */

const PRIVATE_KEY = process.env.PRIVATE_KEY ?? "";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },

  networks: {
    hardhat: {
      chainId: 31337,
    },

    somnia: {
      url: process.env.SOMNIA_MAINNET_RPC || "",
      chainId: 5031, // Somnia Mainnet
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
    },
  },

  paths: {
    sources: "contracts",
    tests: "test",
    cache: "cache",
    artifacts: "artifacts",
  },

  mocha: {
    timeout: 60000,
  },
};

export default config;
