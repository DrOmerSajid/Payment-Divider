// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import 'hardhat/console.sol';

contract PaymentSplitter{
    event PaymentReceived(address from, uint amount);

    uint public _totalShares;
    uint public _totalReleased;
    address public owner;

    mapping(address => uint) public _shares;
    mapping(address => uint) public _released;

    address payable[] public  _payees;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }


    constructor(address[] memory payees, uint[] memory shares_)  {
    require(payees.length == shares_.length, "Payees and shares are not equal");
    require(payees.length > 0, "No payees");
    owner = msg.sender;
    for(uint i = 0; i< payees.length; i++){
       // console.log("address",payees[i]);
        if(payees[i] != address(0)){
            _shares[payees[i]] = shares_[i];
            _payees.push(payable(payees[i]));
            _totalShares+=shares_[i];
        }
    }
    }

    receive() external payable{
        emit PaymentReceived(msg.sender, msg.value);
    }

    function releaseAll() public onlyOwner payable{

        uint256 balance = getBalance();
        
         for (uint i =0 ; i < _payees.length ; i++){
             address payable temp = payable(_payees[i]);

             uint temp1 =  (balance * (_shares[temp])) / 100;
             console.log("_shares[temp]",_shares[temp] );
             console.log("temp1:", temp1);            
             temp.transfer(temp1);
              _released[temp] = temp1;
         }
    }


    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

}

//["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"]
//[40,30,20]