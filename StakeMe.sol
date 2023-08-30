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
}