require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");

const { API_URL, PRIVATE_KEY } = process.env;
// console.log(API_URL, PRIVATE_KEY);

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
      // localhost: {
      //     url: "http://localhost:8545"
      // },
 hardhat: {
   chainId: 1337
 },
},
solidity: "0.8.9",
 paths: {
     artifacts: './client/src/artifacts',
 },
};

//Matic mumbai
// module.exports = {
//     solidity: "0.8.9",
//     defaultNetwork: "polygon_mumbai",
//     networks: {
//         hardhat: {},
//         polygon_mumbai: {
//             url: API_URL,
//             accounts: [`0x${PRIVATE_KEY}`]
//         }
//     },
//      paths: {
//      artifacts: './client/src/artifacts',
//  },
// }

