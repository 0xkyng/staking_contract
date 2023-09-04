// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IStandardToken} from "./IStandardToken.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakeMe is ERC20{
    IStandardToken standardToken;
    uint256 min_stake_duration = 1 minutes;
    uint8 rate = 3;
    uint8 percentage = 100;
    uint public contractBalance;
    
    

    struct User {
        uint amountStaked;
        uint timeStaked;
    }
    event Staked(uint amountStake, uint totalAmountStaked, uint time);

    mapping (address => User) user;

    constructor(address _standardToken) ERC20("STAKING_REWARDS_TOKEN", "SRT"){
       standardToken = IStandardToken(_standardToken);
    }

    // Stake your standard tken
    function stake(uint amount) external {
         uint balance = standardToken.balanceOf(msg.sender);
         require(balance >= amount, "Insufficient balance");
         bool success = standardToken.transferFrom(msg.sender, address(this), amount);
         require(success, "transfer failed");
         User storage staker = user[msg.sender];
         staker.amountStaked+= amount;
         staker.timeStaked = block.timestamp;
         emit Staked(amount, staker.amountStaked, block.timestamp);
    }

    // get the amount the user staked
    function getStake() external view returns (uint _staked) {
        User storage staker = user[msg.sender];
        _staked = staker.amountStaked;
    }

    // user can withraw staked token
    function withdraw(uint amount) external {
        User storage staker = user[msg.sender];
        uint totalStaked = staker.amountStaked;
        require(totalStaked >= amount);
        staker.amountStaked -= amount;
        standardToken.transfer(msg.sender, amount);
    }
}