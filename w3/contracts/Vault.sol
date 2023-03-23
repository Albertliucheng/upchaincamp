// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./interface/IAlbertToken.sol";

contract Vault {
    using SafeERC20 for IAlbertToken;
    address public token;
    bytes4 private constant SELECTOR =
        bytes4(keccak256(bytes("transfer(address,uint256)")));
    mapping(address => uint) public balances;

    constructor(address _addr) {
        token = _addr;
    }

    function deposite(uint256 _value) public {
        balances[msg.sender] += _value;
        IAlbertToken(token).safeTransferFrom(msg.sender, address(this), _value);
    }

    function depositePermit(
        uint256 _value,
        uint _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public {
        IAlbertToken(token).permit(
            msg.sender,
            address(this),
            _value,
            _deadline,
            _v,
            _r,
            _s
        );
        deposite(_value);
    }

    function withdraw(uint256 _value) public {
        require(balances[msg.sender] >= _value, "Vault: INSUFFICIENT");
        balances[msg.sender] -= _value;
        IAlbertToken(token).safeTransfer(msg.sender, _value);
    }
}
