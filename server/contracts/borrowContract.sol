// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract BorrowContract {
    struct BorrowRequest {
        address borrower;
        uint amount;
        string purpose;
        uint interestRate;
        uint paybackPeriod;
        bool isApproved;
        bool isFulfilled;
        string status; // "pending", "approved", "rejected"
    }

    struct Transaction {
        uint requestId;
        address user;
        string action; // "created", "approved", "rejected"
        uint timestamp;
    }

    uint public borrowRequestCount = 0;
    mapping(uint => BorrowRequest) public borrowRequests;
    Transaction[] public transactions;
    mapping(address => uint[]) public userTransactions;

    event BorrowRequestCreated(uint requestId, address borrower, uint amount, string purpose);
    event TransactionHistory(uint requestId, address user, string action, uint timestamp);

    function recordTransaction(uint _requestId, address _user, string memory _action) private {
        transactions.push(Transaction(_requestId, _user, _action, block.timestamp));
        uint transactionId = transactions.length - 1;
        userTransactions[_user].push(transactionId);
        emit TransactionHistory(_requestId, _user, _action, block.timestamp);
    }

    function createBorrowRequest(uint _amount, string memory _purpose, uint _interestRate, uint _paybackPeriod) public {
        borrowRequestCount++;
        borrowRequests[borrowRequestCount] = BorrowRequest(msg.sender, _amount, _purpose, _interestRate, _paybackPeriod, false, false, "pending");
        emit BorrowRequestCreated(borrowRequestCount, msg.sender, _amount, _purpose);
        recordTransaction(borrowRequestCount, msg.sender, "created");
    }

    // Placeholder for other functions like approveBorrowRequest, rejectBorrowRequest, etc.
    // Ensure to include transaction recording in these functions as well.
}