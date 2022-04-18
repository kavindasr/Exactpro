// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract p2pExchange {
    struct Exchange {
        uint amount;
        bytes32 eType;
        uint rate;
        address owner;
        complete
    }

    struct Deposit {
        bytes32 currency;
        uint amount;
    }

    struct Account {
        Deposit[] deposits;
    }

    mapping(address => Account) accounts;
    Exchange[] public exchanges;

    function deposit(uint amount_, bytes32 currency_) public {
        Account storage account_ = accounts[msg.sender];
        account_.deposits.push(Deposit({
            currency: currency_;
            amount: amount_;
        }));
    }

    
}