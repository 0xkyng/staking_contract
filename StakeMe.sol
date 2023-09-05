// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IStandardToken} from "./IStandardToken.sol";

// import ERC20 from openzeppelin
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakeMe is ERC20 {
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

    mapping(address => User) user;

    constructor(address _standardToken) ERC20("STAKING_REWARDS_TOKEN", "SRT") {
        standardToken = IStandardToken(_standardToken);
    }

    // Stake your standard tken
    function stake(uint amount) external {
        uint balance = standardToken.balanceOf(msg.sender);
        require(balance >= amount, "Insufficient balance");
        bool success = standardToken.transferFrom(
            msg.sender,
            address(this),
            amount
        );
        require(success, "transfer failed");
        User storage staker = user[msg.sender];
        staker.amountStaked += amount;
        staker.timeStaked = block.timestamp;
        emit Staked(amount, staker.amountStaked, block.timestamp);
    }

    // get the amount the user staked
    function getStake() external view returns (uint _staked) {
        User storage staker = user[msg.sender];
        _staked = staker.amountStaked;
    }

    // user can withraw staked token
    function withdraw() public {
        uint withdrawableBalance = user[msg.sender].amountStaked;
        uint256 _stakeTime = user[msg.sender].timeStaked;
        uint256 _stakeWithdrawalTime = _stakeTime + min_stake_duration;

        if (_stakeWithdrawalTime > block.timestamp) {
            revert("Not withdrawal timee yet");
        } else {
            require(withdrawableBalance > 0, "Insufficient staked balance");

            uint256 calcStake = (withdrawableBalance * rate) / percentage;
            uint256 stakeDuration = (block.timestamp - _stakeTime) /
                min_stake_duration;
            uint256 stakeReward = stakeDuration * calcStake;
            standardToken.transfer(msg.sender, withdrawableBalance);
            _mint(msg.sender, stakeReward);

            contractBalance -= user[msg.sender].amountStaked;
            user[msg.sender].amountStaked = 0;
        }
    }
}
