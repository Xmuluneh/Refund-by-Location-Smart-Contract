require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    localhost: {
      url: "http://localhost:7545", // Use the default Hardhat network URL
      accounts: [
        "0x5099112334b72bb370da733ce5e174af25c307cd"
      ]
    }
  }
};
