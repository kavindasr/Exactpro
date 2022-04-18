// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract p2pExchange {
    struct Exchange {
        uint amount;
        string from;
        string to;
        uint rate;
        address owner;
        bool complete;
    }

    struct Account {
        mapping(string => uint) deposits;
    }

    mapping(address => Account) accounts;
    Exchange[] public exchanges;

    function deposit(uint amount_, string memory currency_) public {
        Account storage account = accounts[msg.sender];
        account.deposits[currency_] += amount_;
    }

    function makeRequest(uint amount_, string memory from_, string memory to_, uint rate_) public {
        Account storage account = accounts[msg.sender];
        require(account.deposits[from] >= rate_ * amount_, "Does not have enough balance");
        account.deposits[from] -= rate_ * amount_;

        Exchange storage exchange_ = Exchange({
            amount: amount_,
            from: from_,
            to: to_,
            rate: rate_,
            owner: msg.sender,
            complete: false
        });
        for(uint i=0; i < exchanges.length; i++) {
            Exchange storage ex_ = exchanges[i];
            if(ex_.complete) {
                continue;
            }
            if(!(ex_.to == from_ && ex_.from == to_)) {
                continue;
            }
            if(ex_.amount * ex_.rate <= rate_ * amount_) {
                account.deposits[from_] += rate_ * amount_ - ex_.amount * ex_.rate;
                account.deposits[to_] += amount_;
                exchange_.complete = true;

                Account storage sAccount = accounts[ex_.owner];
                sAccount.deposits[from_] -= amount_;
                sAccount.deposit[to_] += ex_.amount * ex_.rate;
                ex_.complete = true;
            }
        }
        exchanges.push(exchange_);
    }

}