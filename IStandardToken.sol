// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IStandardToken {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address owner) external view  returns(uint);
    function transfer(address to, uint256 amount) external returns (bool);
}