// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IVault {
    function deposit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function withdraw(uint256 _value) external;
}
