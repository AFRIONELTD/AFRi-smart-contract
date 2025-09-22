// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract AFRi is ERC20, Ownable2Step, EIP712 {
    using ECDSA for bytes32;

    // Admin management
    mapping(address => bool) private _admins;
    
    // Meta-transaction management
    mapping(bytes32 => bool) private _usedNonces;
    mapping(address => uint256) private _nonces;
    
    
    // EIP-712 type hashes
    bytes32 private constant TRANSFER_TYPEHASH = keccak256(
        "Transfer(address from,address to,uint256 amount,uint256 nonce,uint256 deadline,uint256 gasCostUSD)"
    );
    
    bytes32 private constant APPROVE_TYPEHASH = keccak256(
        "Approve(address owner,address spender,uint256 amount,uint256 nonce,uint256 deadline,uint256 gasCostUSD)"
    );

    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);
    event TokensBurned(address indexed account, uint256 amount);
    event MetaTransfer(address indexed from, address indexed to, uint256 amount, uint256 gasCost);
    event MetaApprove(address indexed owner, address indexed spender, uint256 amount, uint256 gasCost);

    constructor(address owner) ERC20("AFRi", "AFRi") Ownable(owner) EIP712("AFRi", "1") {
    
    }

    modifier onlyAdmin() {
        require(_admins[msg.sender], "AFRi: caller is not an admin");
        _;
    }



    // Admin functions
    function addAdmin(address admin) public onlyOwner {
        require(admin != address(0), "AFRi: admin is the zero address");
        require(admin != owner(), "AFRi: owner cannot be admin");
        require(!_admins[admin], "AFRi: already an admin");
        _admins[admin] = true;
        emit AdminAdded(admin);
    }

    function removeAdmin(address admin) public onlyOwner {
        require(_admins[admin], "AFRi: not an admin");
        _admins[admin] = false;
        emit AdminRemoved(admin);
    }

    function isAdmin(address admin) public view returns (bool) {
        return _admins[admin];
    }

    function mint(address to, uint256 amount) public onlyAdmin {
        _mint(to, amount);
    }

    // Admin burn function
    function burnFrom(address account, uint256 amount) public onlyAdmin {
        require(account != address(0), "AFRi: burn from the zero address");
        require(balanceOf(account) >= amount, "AFRi: burn amount exceeds balance");
        
        _burn(account, amount);
        emit TokensBurned(account, amount);
    }


    // Meta-transaction functions
    function metaTransfer(
        address from,
        address to,
        uint256 amount,
        uint256 nonce,
        uint256 deadline,
        uint256 gasCostUSD, // Pre-calculated gas cost in USD (since 1 AFRi = $1)
        bytes memory signature
    ) public onlyAdmin {
        require(block.timestamp <= deadline, "AFRi: transaction expired");
        require(!_usedNonces[keccak256(abi.encodePacked(from, nonce))], "AFRi: nonce already used");
        require(gasCostUSD > 0, "AFRi: gas cost must be greater than 0");
        
        // Verify signature (include gasCostUSD in signature)
        bytes32 structHash = keccak256(abi.encode(
            TRANSFER_TYPEHASH,
            from,
            to,
            amount,
            nonce,
            deadline,
            gasCostUSD
        ));
        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = hash.recover(signature);
        require(signer == from, "AFRi: invalid signature");
        
        // Mark nonce as used
        _usedNonces[keccak256(abi.encodePacked(from, nonce))] = true;
        
        // Check if user has enough balance for transfer + gas cost
        require(balanceOf(from) >= amount + gasCostUSD, "AFRi: insufficient balance for transfer and gas");
        
        // Execute transfer
        _transfer(from, to, amount);
        
        // Deduct gas cost from user's balance (gasCostUSD is already in AFRi tokens since 1 AFRi = $1)
        _transfer(from, owner(), gasCostUSD);
        
        emit MetaTransfer(from, to, amount, gasCostUSD);
    }

    function metaApprove(
        address owner,
        address spender,
        uint256 amount,
        uint256 nonce,
        uint256 deadline,
        uint256 gasCostUSD, // Pre-calculated gas cost in USD (since 1 AFRi = $1)
        bytes memory signature
    ) public onlyAdmin {
        require(block.timestamp <= deadline, "AFRi: transaction expired");
        require(!_usedNonces[keccak256(abi.encodePacked(owner, nonce))], "AFRi: nonce already used");
        require(gasCostUSD > 0, "AFRi: gas cost must be greater than 0");
        
        // Verify signature (include gasCostUSD in signature)
        bytes32 structHash = keccak256(abi.encode(
            APPROVE_TYPEHASH,
            owner,
            spender,
            amount,
            nonce,
            deadline,
            gasCostUSD
        ));
        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = hash.recover(signature);
        require(signer == owner, "AFRi: invalid signature");
        
        // Mark nonce as used
        _usedNonces[keccak256(abi.encodePacked(owner, nonce))] = true;
        
        // Check if user has enough balance for gas cost
        require(balanceOf(owner) >= gasCostUSD, "AFRi: insufficient balance for gas");
        
        // Execute approval
        _approve(owner, spender, amount);
        
        // Deduct gas cost from user's balance (gasCostUSD is already in AFRi tokens since 1 AFRi = $1)
        _transfer(owner, owner(), gasCostUSD);
        
        emit MetaApprove(owner, spender, amount, gasCostUSD);
    }

    // Utility functions
    function getNonce(address user) public view returns (uint256) {
        return _nonces[user];
    }

    function incrementNonce(address user) public onlyAdmin {
        _nonces[user]++;
    }

    // Standard ERC20 functions
    function transfer(address to, uint256 amount) public override returns (bool) {
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        return super.transferFrom(from, to, amount);
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        return super.approve(spender, amount);
    }
} 