module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*", // Match any network id
    },
    advanced: {
      websockets: true, // Enable EventEmitter interface for web3 (default: false)
    },
  },
  contracts_build_directory: "./abis/",
  compilers: {
    solc: {
      version: "^0.8.10",
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};