// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

contract Africoin is ERC20, Ownable2Step {
    mapping(address => bool) private _admins;

    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);

    constructor(address owner) ERC20("Africoin", "AFC") Ownable(owner) {
    
    }

    modifier onlyAdmin() {
        require(_admins[msg.sender], "Africoin: caller is not an admin");
        _;
    }

    function addAdmin(address admin) public onlyOwner {
        require(admin != address(0), "Africoin: admin is the zero address");
        require(admin != owner(), "Africoin: owner cannot be admin");
        require(!_admins[admin], "Africoin: already an admin");
        _admins[admin] = true;
        emit AdminAdded(admin);
    }

    function removeAdmin(address admin) public onlyOwner {
        require(_admins[admin], "Africoin: not an admin");
        _admins[admin] = false;
        emit AdminRemoved(admin);
    }

    function isAdmin(address admin) public view returns (bool) {
        return _admins[admin];
    }

    function mint(address to, uint256 amount) public onlyAdmin {
        _mint(to, amount);
    }
} 