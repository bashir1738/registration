// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./IUserRegistration.sol";

contract UserRegistration is IUserRegistration {
    address public admin;
    mapping(address => User) public users;
    mapping(address => bool) public registered;
    address[] public userList;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this");
        _;
    }

    modifier onlyRegistered() {
        require(registered[msg.sender], "User not registered");
        _;
    }

    modifier userExists(address _userAddress) {
        require(registered[_userAddress], "User does not exist");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerUser(string memory _name, string memory _email, string memory _gender) external {
        require(!registered[msg.sender], "User already registered");
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_email).length > 0, "Email cannot be empty");
        require(bytes(_gender).length > 0, "Gender cannot be empty");

        users[msg.sender] = User(_name, _email, _gender, false);
        registered[msg.sender] = true;
        userList.push(msg.sender);

        emit UserRegistered(msg.sender, _name, _email);
    }

    function getUser(address _userAddress) external view userExists(_userAddress) returns (User memory) {
        return users[_userAddress];
    }

    function getUserDetails() external view onlyRegistered returns (User memory) {
        return users[msg.sender];
    }

    function getAllUsers() external view onlyAdmin returns (address[] memory) {
        return userList;
    }

    function suspendUser(address _userAddress) external onlyAdmin userExists(_userAddress) {
        require(!users[_userAddress].isSuspended, "User already suspended");
        users[_userAddress].isSuspended = true;
        emit UserSuspended(_userAddress);
    }

    function unsuspendUser(address _userAddress) external onlyAdmin userExists(_userAddress) {
        require(users[_userAddress].isSuspended, "User is not suspended");
        users[_userAddress].isSuspended = false;
        emit UserUnsuspended(_userAddress);
    }

    function isRegistered(address _userAddress) external view returns (bool) {
        return registered[_userAddress];
    }

    function isSuspended(address _userAddress) external view userExists(_userAddress) returns (bool) {
        return users[_userAddress].isSuspended;
    }

    function changeAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }
}
