// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SecureSystem {
    address public owner;
    mapping(address => uint256) public userBalances;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    // Constructor: Set the owner of the contract
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    // Deposit function: Allow users to deposit funds
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        userBalances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Withdrawal function: Allow users to withdraw their funds
    function withdraw(uint256 amount) external {
        require(amount <= userBalances[msg.sender], "Insufficient balance");
        userBalances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    // Owner function to withdraw all funds from the contract
    function ownerWithdraw(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient contract balance");
        payable(owner).transfer(amount);
    }

    // Check balance of a user
    function balanceOf(address user) external view returns (uint256) {
        return userBalances[user];
    }
}
