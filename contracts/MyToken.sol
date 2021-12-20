// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;


contract Alien {
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 public totalSupply;

    // to keeo track balances
    mapping(address => uint256) public balanceOf;


    // Fire event on state change and etc
    event Transfer(address indexed from, address indexed to, uint256 value);

    
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
        // check if the address is valid
        require(_to != address(0));
        // take the value from the accounts of the sender
        balanceOf[_from] = balanceOf[_from] - (_value);
        // add the value sent to the receiver
        balanceOf[_to] = balanceOf[_to] + (_value);
        emit Transfer(_from, _to, _value);
    }





}