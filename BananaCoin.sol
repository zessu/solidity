// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// allow creator to create new coins
// holders can send each others coins
contract BananaCoin {
    address public minter;

    mapping(address => uint) public balances;

    constructor() public payable {
        minter = msg.sender;
    }

    modifier isCreator() {
        require(msg.sender == minter);
        _;
    }

    // mint coins and send them to an address
    function mint(address receiver, uint amount) isCreator public {
        balances[receiver] += amount;
    }

    event Sent(address from, address to, uint amount);

    error insufficientBalance(uint balance, uint requestedAmount);

    function transferCoins(address to, uint amount) public {
        if(balances[msg.sender] < amount) {
            revert insufficientBalance({balance: balances[msg.sender], requestedAmount: amount});
        }
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Sent(msg.sender, to, amount);
    }
}
