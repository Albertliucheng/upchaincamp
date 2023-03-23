// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IAlbertToken is IERC20{

    function permit(address owner,address spender,uint value,uint deadline,uint8 v,bytes32 r,bytes32 s) external ;
}
