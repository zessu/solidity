// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Will {
    address owner;
    uint amount;
    bool deceased;

    constructor() payable public {
        owner = msg.sender;
        amount = msg.value;
        deceased = false;
    }

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier isDeceased() {
        require(deceased == true);
        _;
    }
   
   address payable[] familyWallets;

   mapping(address => uint) familyMap;

   function setInheritance (address payable walletAddress, uint amt) isOwner public {
       familyWallets.push(walletAddress);
       familyMap[walletAddress] = amt;
   }

   function payout() isDeceased private {
       for (uint i = 0; i < familyWallets.length; i++) {
           address wallet = familyWallets[i];
           familyWallets[i].transfer(familyMap[wallet]); // can we use a dictionaty for this?
        }
    }

    // called by some kind of oracle or managed address owner
    function ownerDeceased() isOwner public {
        deceased = true;
        payout();
    }
}
