// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import { Africoin } from "../src/Africoin.sol";

contract DeployAfricoin is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        uint256 initialSupply = vm.envUint("INITIAL_SUPPLY");
        vm.startBroadcast(deployerPrivateKey);
        Africoin africoin = new Africoin(initialSupply);
        vm.stopBroadcast();
    }
} 