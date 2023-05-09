// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage {

    modifier notHaveAccount() {
        require(hasAccount[msg.sender] == false);
        _;
    }

    modifier haveAccount() {
        require(hasAccount[msg.sender] == true);
        _;
    }

    struct Ticket {
        string name;
        uint16 count;
    }

    mapping(address => bool) hasAccount;
    mapping(address => Ticket) TicketOwner;

}