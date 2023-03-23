// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AlbertToken is ERC20("AlbertToken", "AT") {
    bytes32 public DOMAIN_SEPARATOR;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant PERMIT_TYPEHASH =
        0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public nonces;

    constructor() {
        _mint(msg.sender, 100000 * 10 ** decimals());
        uint chainId = block.chainid;

        DOMAIN_SEPARATOR = keccak256( //域分隔符，唯一确定合约
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes(name())), //名称
                keccak256(bytes("1")), //版本号
                chainId, //链id
                address(this) //合约地址
            )
        );
    }

    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(deadline >= block.timestamp, "AlbertToken: EXPIRED");
        bytes32 digest = keccak256( //签名的数据重建：\x19\x01 + DOMAIN_SEPARATOR + HASH_STRUCT
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR, //域分隔符，定位到哪个合约
                keccak256(
                    abi.encode(
                        PERMIT_TYPEHASH,
                        owner,
                        spender,
                        value,
                        nonces[owner]++,
                        deadline
                    )
                ) //定位哪个函数
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(
            recoveredAddress != address(0) && recoveredAddress == owner,
            "AlbertToken: INVALID_SIGNATURE"
        );
        _approve(owner, spender, value); //在有效期内允许spender花这么多金额
    } //使用permit函数，之前转账代币到合约approve + transfer两步变成一步，且可实现用户无gas交易，让平台方提交交易
}
