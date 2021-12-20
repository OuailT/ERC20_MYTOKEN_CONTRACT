// Module to Create the path
const path = require("path");

const lotteryPath = path.resolve(__dirname, "contracts", "Lottery.sol");


// module to Read the path
const fs = require("fs");

const source = fs.readFileSync(lotteryPath, "utf8");

// solidity compiler to compile our contract & get the bytecode and interface

const solc = require("solc");

module.exports = solc.compile(source, 1).contracts[":Lottery"];

// console.log(solc.compile(source, 1));

