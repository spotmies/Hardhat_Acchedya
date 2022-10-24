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

contract CollegeVariables is OwnableUpgradeable {
    using SafeMath for uint;
    using SafeMath for uint32;
    using SafeMath for uint256;

    struct student {
        string[] certs;
        string[] certName;
        string certType;
        uint256 timestamp;
        string AddedBy;
        address collegeAdd;
        uint32 verified;
    }

    struct student2 {
        string collegeName;
        string ID;
        string name;
        string year;
        string course;
        string rollNo;
        string DOJ;
    }

    struct college {
        address collegeWalAddress;
        string collegeName;
        string collegeAddress;
        string collegePhone;
        string collegeEmail;
        uint32 collegeStatus;
        address access;
    }

    mapping(address => uint256) internal collegeIndex;
    mapping(address => mapping(uint256 => student[])) internal studentDetails;
    mapping(address => mapping(uint256 => student2[])) internal studentDetails2;
    mapping(address => college[]) internal collegeDetails;
    mapping(address => bool) internal CollegeAddress;

    mapping(address => uint256) internal colReq;
}
