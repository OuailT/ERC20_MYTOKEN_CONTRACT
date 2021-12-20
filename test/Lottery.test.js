// Assert to compare variables
const assert = require("assert");

// Ganache for local test network
const ganache = require("ganache-cli");

// To have access to the smart contract w require web3
const Web3 = require("web3");

// create an instance of web3 and get the provider from ganache
const web3 = new Web3(ganache.provider());

// Import interface and bytecode
const { interface , bytecode} = require("../compile");

// Global variables
à
let accounts;
let lottery;


beforeEach(async ()=> {
    // Ganache offers 10 accounts for a seek of testing
    accounts = await web3.eth.getAccounts();

    // deploy the contract
    //29-teaches web3 about what methods our contract has
    //31-tells web3 that we want to create a new copy of this contract
    //33- instruct web3 to deploy our contract on ethereum blockchain
    // Lottery represents javascript presentations of the contract on the ethereum blockchain
    lottery = await new web3.eth.Contract(JSON.parse(interface))
              .deploy({data: bytecode})
              .send({from : accounts[0], gas: "1000000"});
});


describe("Lottery", () => {
    // Test if the contract has been deployed
    it("The contract has been deployed", () => {
        // assert.ok check the existence of the value
        assert.ok(lottery.options.address)
    });

    // Test if the players who enters the game sent some money
    // and who send it by using send() methods
    it("allows one player to enter", async () => {
        await lottery.methods.enter().send({
          from : accounts[0],
          value: web3.utils.toWei("0.02", "ether")
        });
    // When a player enter the game we need to get the list of players 
        const players = await lottery.methods.getPlayers().call({
            from: accounts[0]
        });

        // One assert to check if there is one record in the array
        // with assert equal (first arguments it for what the value should be and what the value is it)
        // if the address of the player is it inside the array.
        assert.equal(accounts[0], players[0]);
        // Check if there is at least one players 
        assert.equal(1, players.length);
    });

    // Multiple players to enter test
    it("allows multiple players to enter", async ()=> {
        await lottery.methods.enter().send({
            from: accounts[0],
            value: web3.utils.toWei("0.02", "ether")
        });

        const players = await lottery.methods.getPlayers().call({
            from: accounts[0]
        });

        assert.equal(accounts[0], players[0])
        assert.equal(accounts[1], players[1])
        assert.equal(accounts[2], players[2])

        assert.equal(3, players.length);
    });

    // Assure that the player sent a minimum amount of money
    it('the player send a minimum amount of Ether', async ()=> {
       
       try {
           await  lottery.methods.enter().send({
           from : accounts[0],
           value: 0
       });
            // to assure that the code will fail
            assert(false); 
       } catch (err) {
            assert(err);
       }
    });

    // Check the whole contract
    it("send money to the winner and reset the players array", async ()=> {
        // The winner enter the lottery by 2 ether
        await lottery.methods.enter().send({
            from: accounts[0],
            value: web3.utils.toWei("2", "ether")
        });

        // check the initial balance of the player using we3
        const initialBalance = await web3.eth.getBalance(accounts[0]);

        // Pick a winner
        await lottery.methods.pickWinner().send({
            from: accounts[0],
        });

        // check the Final balance of the player
        const finalBalance = await web3.eth.getBalance(accounts[0]);

        const difference  = finalBalance - initialBalance;
        
        // Check the difference 
        assert(difference >  web3.utils.toWei("1.8", "ether"));
    });

});
    








