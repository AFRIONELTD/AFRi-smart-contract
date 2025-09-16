// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import { AFRi } from "../src/AFRi.sol";

contract DeployAFRi is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.envAddress("OWNER_ADDRESS");
        vm.startBroadcast(deployerPrivateKey);
        AFRi AFRi = new AFRi(owner);
        vm.stopBroadcast();
    }
} 