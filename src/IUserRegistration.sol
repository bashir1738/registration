// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IUserRegistration {
    struct User {
        string name;
        string email;
        string gender;
        bool isSuspended;
    }

    event UserRegistered(address indexed userAddress, string name, string email);
    event UserSuspended(address indexed userAddress);
    event UserUnsuspended(address indexed userAddress);

    function registerUser(string memory _name, string memory _email, string memory _gender) external;
    function getUser(address _userAddress) external view returns (User memory);
    function suspendUser(address _userAddress) external;
    function unsuspendUser(address _userAddress) external;
    function isRegistered(address _userAddress) external view returns (bool);
}
