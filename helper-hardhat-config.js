<<<<<<< HEAD
const {ethers} = require("hardhat");

// ethers version 4 is ethers.utils.parseEther
// ethers version 6 is ethers.parseEther
const networkConfig = {
    11155111 : {
        name : 'sepolia',
        // refer to https://docs.chain.link/vrf/v2/subscription/supported-networks
        // on the testnet and VRF Coordinator value
        vrfCoordinatorV2 : "0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625",
        entranceFee : ethers.parseEther("0.01"),
        // refer to https://docs.chain.link/vrf/v2/subscription/supported-networks
        // on the testnet gwei key hash value
        gasLane : "0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c",
        subscriptionId: "0",
        callBackGasLimit: "500000",
        interval : "30",
    },
    31337 : {
        name : 'hardhat',
        entranceFee : ethers.parseEther("0.01"),
        // doesn't matter for localhardhat, can put anything
        gasLane : "0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c",
        callBackGasLimit: "500000",
        interval : "30",
    },

}

const developmentChains = ["hardhat", "localhost"];
module.exports = {
    networkConfig,
    developmentChains,
}
=======
const { ethers } = require("hardhat")

const networkConfig = {
    default: {
        name: "hardhat",
        keepersUpdateInterval: "30",
    },
    31337: {
        name: "localhost",
        subscriptionId: "588",
        gasLane: "0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c", // 30 gwei
        keepersUpdateInterval: "30",
        raffleEntranceFee: ethers.utils.parseEther("0.01"), // 0.01 ETH
        callbackGasLimit: "500000", // 500,000 gas
    },
    11155111: {
        name: "sepolia",
        subscriptionId: "6926",
        // refer to https://docs.chain.link/vrf/v2/subscription/supported-networks
        // on the testnet gwei key hash value
        gasLane: "0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c", // 30 gwei
        keepersUpdateInterval: "30",
        raffleEntranceFee: ethers.utils.parseEther("0.01"), // 0.01 ETH
        callbackGasLimit: "500000", // 500,000 gas
        // refer to https://docs.chain.link/vrf/v2/subscription/supported-networks
        // on the testnet and VRF Coordinator value
        vrfCoordinatorV2: "0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625",
    },
    1: {
        name: "mainnet",
        keepersUpdateInterval: "30",
    },
}

const developmentChains = ["hardhat", "localhost"]
const VERIFICATION_BLOCK_CONFIRMATIONS = 6
const frontEndContractsFile = "../nextjs-smartcontract-lottery-fcc/constants/contractAddresses.json"
const frontEndAbiFile = "../nextjs-smartcontract-lottery-fcc/constants/abi.json"

module.exports = {
    networkConfig,
    developmentChains,
    VERIFICATION_BLOCK_CONFIRMATIONS,
    frontEndContractsFile,
    frontEndAbiFile,
}
>>>>>>> e9e70396a69da3bf999a70d621aa28cd987cc32d
