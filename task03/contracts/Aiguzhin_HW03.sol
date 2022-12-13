// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VToken is ERC20 {
    constructor() ERC20("VToken", "VTK") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}

contract stake {
    // Data about stakers
    struct staker {
        uint256 startTime;
        uint256 endTime;
        uint256 deposited;
        uint256 claimed;
    }

    mapping(address => staker) public stakerInfo;
    mapping(address => bool) public IS_staker;

    // Just for educational purposes hold period will be 10 seconds
    uint256 private constant period = 10;
    // 32% of staked amount should be rewarded
    uint256 private constant reward = 32;

    VToken tokenInstance;

    constructor(address _tokenAddress) {
        require(
            _tokenAddress != address(0),
            "Zero address's been feeded to me((("
        );
        tokenInstance = VToken(_tokenAddress);
    }

    function Stake(uint256 _depositValue) external {
        require(_depositValue > 0, "You can't stake nothing");
        require(
            IS_staker[msg.sender] == false,
            "You've already staked for this period"
        );
        require(
            tokenInstance.balanceOf(msg.sender) >= _depositValue,
            "Low balance"
        );

        tokenInstance.transferFrom(msg.sender, address(this), _depositValue);
        IS_staker[msg.sender] = true;

        stakerInfo[msg.sender] = staker({
            startTime: block.timestamp,
            endTime: block.timestamp + period,
            deposited: _depositValue,
            claimed: 0
        });
    }

    function Claim(address _holder) external {
        require(IS_staker[_holder] == true, "You haven't made a deposit");
        require(
            stakerInfo[_holder].endTime < block.timestamp,
            "Hold period hasn't finished"
        );

        uint256 prize = (stakerInfo[_holder].deposited * reward) / 100;
        stakerInfo[_holder].claimed = prize;

        tokenInstance.transfer(_holder, prize);
    }

    function Withdraw() external {
        require(IS_staker[msg.sender] == true, "You haven't made a deposit");

        uint256 withdrawn = stakerInfo[msg.sender].deposited;
        tokenInstance.transfer(msg.sender, withdrawn);

        // After withdrawal clear info about a staker
        IS_staker[msg.sender] = false;
        stakerInfo[msg.sender] = staker({
            startTime: 0,
            endTime: 0,
            deposited: 0,
            claimed: 0
        });
    }
}
