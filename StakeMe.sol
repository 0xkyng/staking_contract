// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IStandardToken} from "./IStandardToken.sol";


contract StakeMe {
    IStandardToken standardToken;
    

    struct User {
        uint amountStaked;
        uint timeStaked;
    }
    event Staked(uint amountStake, uint totalAmountStaked, uint time);

    mapping (address => User) user;

    constructor(address _standardToken){
       standardToken = IStandardToken(_standardToken);
    }

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

    function getStake() external view returns (uint _staked) {
        User storage staker = user[msg.sender];
        _staked = staker.amountStaked;
    }

    function withdraw(uint amount) external {
        User storage staker = user[msg.sender];
        uint totalStaked = staker.amountStaked;
        require(totalStaked >= amount);
        staker.amountStaked -= amount;
        standardToken.transfer(msg.sender, amount);
    }
}