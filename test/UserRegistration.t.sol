// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/UserRegistration.sol";

contract UserRegistrationTest is Test {
    UserRegistration public userReg;
    address admin = address(1);
    address user1 = address(2);
    address user2 = address(3);

    function setUp() public {
        vm.prank(admin);
        userReg = new UserRegistration();
    }

    function testRegisterUser() public {
        vm.prank(user1);
        userReg.registerUser("bashir olamide", "gbadamosibashir1738@gmail.com", "Male");

        assertTrue(userReg.isRegistered(user1));
        
        IUserRegistration.User memory user = userReg.getUser(user1);
        assertEq(user.name, "bashir olamide");
        assertEq(user.email, "gbadamosibashir1738@gmail.com");
        assertEq(user.gender, "Male");
        assertFalse(user.isSuspended);
    }

    function testGetUserDetails() public {
        vm.prank(user1);
        userReg.registerUser("bashir olamide", "gbadamosibashir1738@gmail.com", "Male");

        vm.prank(user1);
        IUserRegistration.User memory user = userReg.getUserDetails();
        assertEq(user.name, "bashir olamide");
    }

    function testSuspendUser() public {
        vm.prank(user1);
        userReg.registerUser("bashir olamide", "gbadamosibashir1738@gmail.com", "Male");

        vm.prank(admin);
        userReg.suspendUser(user1);

        IUserRegistration.User memory user = userReg.getUser(user1);
        assertTrue(user.isSuspended);
    }

    function testOnlyAdminCanSuspend() public {
        vm.prank(user1);
        userReg.registerUser("bashir olamide", "gbadamosibashir1738@gmail.com", "Male");

        vm.prank(user2);
        vm.expectRevert("Only admin can call this");
        userReg.suspendUser(user1);
    }

}
