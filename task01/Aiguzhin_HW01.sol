//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/************************************
*        Valikhan Aiguzhin          *
*            HW01                   *
*    ERC20 contract realization     *
*************************************/
contract Token {
    uint256 public total = 1000000e8;

    mapping(address => bool) private ban;
    mapping(address => uint256) public balance_of;
    mapping(address => mapping(address => uint256)) public allow; 

    // Instead of optional functions, i.e. name(), symbol(), decimals()
    string public name = "Valikhan";
    string public symbol = "KZ";
    uint8 public decimal = 18;

    // 'public' visibility only in order to interact through Remix IDE
    // because default value for 'bool' is FALSE
    // then we map blacklisted as TRUE
    // this is needed to make 'require' trigger ONLY on blacklisted
    function blackListAdd(address bad_boy) public{
        ban[bad_boy] = true;
    }

    /********************************************
    *                                           *
    *           ERC20 Standard Interface        *
    *                                           *
    *********************************************/
    function mint() public{
        balance_of[msg.sender] = 500e18;
    }

    function totalSupply() public view returns (uint256){
        return total;
    }

    function balanceOf(address _owner) public view returns (uint256 balance){
        return balance_of[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success){
        // 'require' check whether the sender is in blacklist
        // true - blacklisted
        // false - default value => not in blacklist
        require(ban[msg.sender] == false, "You're an outcast");
        balance_of[msg.sender] -= _value;
        balance_of[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(ban[_from] == false, "You're an outcast");
        allow[_from][_to] -= _value;
        balance_of[_from] -= _value;
        balance_of[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
        allow[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        return allow[_owner][_spender];
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}