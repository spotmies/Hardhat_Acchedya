require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");
require("@openzeppelin/hardhat-upgrades");

require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter");
require("hardhat-deploy");
require("dotenv").config();

const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY;
const localHostKey = process.env.LOCAL_HOST_PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
    },
    localhost: {
      url: "http://localhost:8545",
      chainId: 31337,
      accounts: [localHostKey],
    },
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/your-api-key",
      accounts: [PRIVATE_KEY],
      chainId: 4,
      blockConfirmations: 6,
    },
    goerli: {
      url: GOERLI_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 5,
      blockConfirmations: 6,
    },
  },
  solidity: {
    compilers: [{ version: "0.8.7" }],
  },
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  gasReporter: {
    currency: "USD",
    enabled: true,
    // outputFile: "gas-report.txt",
    nocolour: true,
    coinmarketcap: COINMARKETCAP_API_KEY,
  },
  namedAccounts: {
    deployer: {
      default: 0,
      4: 0,
      5: 0,
    },
    student: {
      default: 1,
    },
  },
};
