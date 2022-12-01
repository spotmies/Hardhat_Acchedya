// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title Acchedya College/Student Contract
/// @author Hemanth Veeranala
/// @notice This contract is used to store/update/retrieve the student details and college details
/// @dev Go through the resources mentioned in the Docs folder before making any changes to the contract. This is a UUPS upgradable contract, so it is better to understand how upgrades work in solidity before making changes.

contract CompanyVariables is OwnableUpgradeable {
    using SafeMath for uint;
    using SafeMath for uint32;
    using SafeMath for uint256;

    ////////////////////////////////
    // company variables
    ////////////////////////////////

    struct company {
        address companyWalAddress;
        string companyName;
        string companyAddress;
        string companyPhone;
        string companyEmail;
        string companySector;
        uint256 companyStatus;
        address access;
        string reserved;
    }

    struct jobRequests {
        address companyAddress;
        address employeeAddress;
        string companyName;
        string employeeName;
        string reasonForInvitation;
        string companyKey;
        uint32 status;
        string reserved;
    }

    // /// // // // // // // // / /
    mapping(address => uint256) internal companyIndex;
    mapping(address => bool) internal CompanyAddress;

    mapping(address => company[]) internal companyDetails;
    mapping(address => jobRequests[]) internal jobInvites;
    // mapping(address => string) internal waiting;
    mapping(address => address[]) internal companyReqs;
    mapping(address => address[]) internal xpCerts;
}
