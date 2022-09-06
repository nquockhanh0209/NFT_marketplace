// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library Permit {

    struct Permitted{
        mapping(address => uint256) nonces;
        mapping(address => mapping(address => uint)) approval;
    }
    function permit(
        Permitted storage new_permit,
        address holder, 
        address taker, 
        uint256 nonce, 
        uint256 deadline, 
        bool isPermitted, 
        uint8 v, 
        bytes32 r, 
        bytes32 s) internal 
    {
        bytes32 DOMAIN_SEPARATOR = keccak256(abi.encode(
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
            keccak256(bytes("PERMIT")),
            keccak256(bytes("1")),
            31337,
            address(this)
        ));

        bytes32 PERMIT_TYPEHASH = 
        
        keccak256("permit(address holder, address taker, uint nonce, uint deadline, bool isPermitted)");
        
        bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH,
                                 holder,
                                 taker,
                                 nonce,
                                 deadline,
                                 isPermitted));
        bytes32 EIP721hash = keccak256(abi.encodePacked(
            "\x19\x01",
            DOMAIN_SEPARATOR,
            structHash
            ));
        
        require(holder != address(0),"invalid holder");
        require(holder == ecrecover(EIP721hash, v, r, s), "invalid owner");
        require(deadline == 0 || deadline >= block.timestamp, "permit expired");
        new_permit.nonces[holder]++;
        uint check = isPermitted ? type(uint).max : 0;
        new_permit.approval[holder][taker] = check;
    }
}