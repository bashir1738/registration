// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/UserRegistration.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        UserRegistration userRegistration = new UserRegistration();
        console.log("UserRegistration deployed at:", address(userRegistration));

        vm.stopBroadcast();
    }
}
