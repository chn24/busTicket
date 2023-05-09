//SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import "./Storage.sol";
import "hardhat/console.sol";
import "./Customer.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract Transaction is Storage{

    modifier notOwner() {
        require(msg.sender != i_owner,"Owner can't pay for this transaction");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner,"Only owner cant withdraw the ETH");
        _;
    }

    modifier verifyAmount(uint16 _amount) {
        require(TicketOwner[msg.sender].count >= _amount,"Your days amount not enough");
        _;
    }

    address public immutable i_owner;
    address public funder;
    uint256 public immutable i_fee;
    uint16 immutable i_dayAmount;
    bool isDone = false;
    bool isWithdraw = false;

    constructor(address _customer, uint256 _fee, uint16 _amount) {
        i_owner = _customer;
        i_fee = _fee;
        i_dayAmount = _amount;
        // customer = Customer(_customers)
    }

    function getFee()public view returns(uint256) {
        return i_fee;
    }

    function getOwner() public view returns(address) {
        return i_owner;
    }

    function getUserDays() public view returns(uint16) {
        return TicketOwner[msg.sender].count;
    }

    function fund() public payable notOwner haveAccount{
        console.log("log 1");
        require(isDone == false, "This transaction is done");
        require(msg.value >= i_fee,"not enough ETH");
        TicketOwner[i_owner].count -= i_dayAmount;
        funder = msg.sender;
        isDone = true;
        TicketOwner[msg.sender].count += i_dayAmount;
console.log("log 1");

        // owner withdraw token
        //  call{value: address(this).balance}("");
    }

    function withdraw() public {
        require(isWithdraw == false);
        (bool callSuccess, ) = payable(i_owner).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
        isWithdraw = true;
    }

    // receive() external payable {
    //     fund();
    // }

    // fallback() external payable {

    // }

}