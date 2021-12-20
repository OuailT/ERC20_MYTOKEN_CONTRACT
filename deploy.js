// To deploy our contract we should install the truffle//provider 
// npm install @truffle/hdwallet-provider 

// The truffle provider
const HDwalletProvider = require("@truffle/hdwallet-provider");

// Required Web3
const Web3 = require("web3");

// import the interface and bytecode
const {interface, bytecode} = require("./compile.js");

// Connect my provider with our metamask accounts and the infura API
const provider = new HDwalletProvider(
    "visual junior kingdom sound play welcome powder earn tag seek scissors spider",
    "https://rinkeby.infura.io/v3/b07c048d810e4e64881be506203a2916"
);


// Connect my provider with web3 and use it to deploy
const web3 = new Web3(provider);


// In order to use await we need to create async function
const deploy = async () => {
    // let get the accounts first
    const accounts = await web3.eth.getAccounts();
    console.log("Attempting to deploy from account", accounts[0])

    const result = await new web3.eth.Contract(JSON.parse(interface))
                    .deploy({ data: bytecode})
                    .send({from : accounts[0], gas : "1000000"})

    console.log("Contract deployed to this address", result.options.address)
    console.log(interface);
    // To prevent hanging development               
    provider.engine.stop();
}   

deploy();
