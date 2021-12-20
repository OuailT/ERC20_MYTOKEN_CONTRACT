// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    // variables storage // will be forever stored on the etherum blockchain
    // using public or private doesn't inssure the security of the data inside my Contract
    address public manager;
    address payable[] public players;
    
    constructor() {
        manager = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value > .01 ether,
                "A minimum payment of .01 ether must be sent to enter the lottery"
        );
        
        players.push(payable(msg.sender));
    }
    
    // to get a hash and convert it to random number using uint function
    // Now => currentTime
    function random() private view returns(uint256){
       return
            uint256(
                keccak256(
                    abi.encodePacked(block.difficulty, block.number, players)
                )
            );
    }
    
    // Pick Winner function
    function pickWinner()  public restricted {
        // we use require so only the manager can call the function( to inforce security)
        //  require(msg.sender == manager);
        // to get a random players
        uint256 index = random() % players.length;

        // To get the address contract
         address contractAddress = address(this);

        // transfer the balance to winner
        players[index].transfer(contractAddress.balance);
        // Empty players arrays
        players = new address payable[](0);
    }
    
    // modifier keywords allows us to not repeat the same code
    modifier restricted()  {
        require(msg.sender == manager);
        _;
    }

    // to get the list of all the players
    function getPlayers() public view returns(address payable[] memory) {
        return players;
    }
    

}