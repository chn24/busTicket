//SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import "./Storage.sol";

import "./Transaction.sol";
import "hardhat/console.sol";

contract Customer is Storage {
    uint256 public constant ticketFee = 2*10**18;

    Transaction[] public trxList ;

    modifier dayAmountAvailable() {
        require(TicketOwner[msg.sender].count <= 5);
        _;
    }

    function createTicket(string memory _name) public notHaveAccount {
        TicketOwner[msg.sender] = Ticket(_name,0);
        hasAccount[msg.sender] = true;
    }

    function buyMonthlyTicket() public payable haveAccount dayAmountAvailable{
        require(msg.value == ticketFee);
        TicketOwner[msg.sender].count += 31;
        payable(address(0)).transfer(msg.value);
    }

    function getDayAvailable()public view returns(uint16){
        return TicketOwner[msg.sender].count;
    }

//Transaction

    function createTrx(uint256 _fee, uint16 _amount) public {
        trxList.push(new Transaction(msg.sender, _fee, _amount));
    }

    function getCount(uint256 trxIndex) public  view returns(uint16){
        return trxList[trxIndex].getUserDays();
    }

    function getTrxFee(uint256 trxIndex) public view returns(uint256){
        return trxList[trxIndex].getFee();
    }

    function getTrxOwner(uint256 trxIndex) public view returns(address){
        return trxList[trxIndex].getOwner();
    }

    function fundTrx(uint256 trxIndex) public payable {
        trxList[trxIndex].fund{value:msg.value}();
    }

    function withdrawTrx(uint256 trxIndex) public {
        trxList[trxIndex].withdraw();
    }
}