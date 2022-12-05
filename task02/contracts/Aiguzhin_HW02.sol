//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/************************************
 *        Valikhan Aiguzhin          *
 *            HW02                   *
 *    ERC20 contract realization     *
 *************************************/
contract ValikhanToken {
    uint256 public total = 1000000e18;
    address public minter;

    string NAME = "ValikhanToken";
    string SYMBOL = "KZ";
    uint DECIMALS = 18;

    mapping(address => bool) private banned;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allow;

    // 'public' visibility only in order to interact through Remix IDE
    // because default value for 'bool' is FALSE
    // then we map blacklisted as TRUE
    // this is needed to make 'require' trigger ONLY on blacklisted
    function blackListAdd(address bad_boy) public {
        require(msg.sender == minter, "You're not the contract creator");
        require(bad_boy != address(0), "Incorrect address!");
        banned[bad_boy] = true;
    }

    /********************************************
     *                                           *
     *           ERC20 Standard Interface        *
     *                                           *
     *********************************************/
    constructor() {
        minter = msg.sender;
    }

    function name() public view returns (string memory) {
        return NAME;
    }

    function symbol() public view returns (string memory) {
        return SYMBOL;
    }

    function decimals() public view returns (uint) {
        return DECIMALS;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter, "You're not the contract creator");
        balances[receiver] += amount;
    }

    function totalSupply() public view returns (uint256) {
        return total;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        // 'require' check whether the sender is in blacklist
        // true - blacklisted
        // false - default value => not in blacklist
        require(banned[msg.sender] == false, "You're an outcast!");
        require(_to != address(0), "Incorrect address!");
        require(balances[msg.sender] >= _value, "Insufficient balance");

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(banned[msg.sender] == false, "You're an outcast!");
        require(_to != address(0), "Incorrect address!");
        require(balances[_from] >= _value, "Insufficient balance");

        allow[_from][_to] -= _value;
        balances[_from] -= _value;
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allow[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256) {
        return allow[_owner][_spender];
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}
