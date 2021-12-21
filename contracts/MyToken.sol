// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;


contract Alien {
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 public totalSupply;

    // to keep track balances
    mapping(address => uint256) public balanceOf;
    // keep track of my address and all the address that are allowed to spend tokens on my behaf.
    mapping(address => mapping(address=> uint256)) public allowance;
    


    // Fire event on state change and etc
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor(string memory _name, string memory _symbol, uint256 _decimals, uint256 _totalSupply ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        // asign the total supply to the owner of the token
        balanceOf[msg.sender] = totalSupply;
        
    }

    // transfer amount of tokens to an address
    /// @param _to receiver of token
    /// @param _value amount value of token to send
    /// @return success as true, for transfer
    function transfer(address _to, uint256 _value) external returns (bool success) {
        // Check if the address had token(_value) in the balance to transfer
        require(balanceOf[msg.sender] >= _value);
        _transfer(msg.sender, _to, _value);
        return true; 
    }


    // Internal Helper function with safety check
    function _transfer(address _from, address _to, uint256 _value) internal {
        // // Ensure sending is to valid address
        require(_to != address(0));
        // take the value from the accounts of the sender
        balanceOf[_from] = balanceOf[_from] - (_value);
        // add the value sent to the receiver
        balanceOf[_to] = balanceOf[_to] + (_value);
        emit Transfer(_from, _to, _value);
    }

    // the first step is to approve to uniswap to exchange tokens.
    // _spender => uniswap address
    // _value => the amount of tokens that uniswap want to swap 
    function approve(address _spender, uint256 _value) external returns(bool) {
        //check if the address of the spender is valid
        require(_spender != address(0));
        // add uniswap in the list of my allowance
        allowance[msg.sender][_spender] = _value;
        // emit the approve 
        emit Approval(msg.sender, _spender, _value);
        return true;

    }


    // transfer by approved person from original address of an amount within approved limit
    // the second step exchange tokens after have been approuved
    function transferFrom(address _from, address _to, uint256 _value) external returns(bool) {
        require(balanceOf[_from] >= _value);
        require(allowance[_from][msg.sender] >= _value);
        allowance[_from][msg.sender] = allowance[_from][msg.sender] - (_value);
        _transfer(_from, _to, _value);
        return true;
    }





}