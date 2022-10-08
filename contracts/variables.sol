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

contract variables is OwnableUpgradeable {
    using SafeMath for uint;
    using SafeMath for uint32;
    using SafeMath for uint256;

    ////////////////////////////////
    // company variables
    ////////////////////////////////

    struct employee {
        string joiningDate;
        string leftDate;
        string designation;
        uint256 timestamp;
        string[] certs;
        string[] certName;
        string certType;
        string AddedBy;
        address companyAdd;
        uint32 verified;
    }

    struct company {
        address companyWalAddress;
        string companyName;
        string companyAddress;
        string companyPhone;
        string companyEmail;
        string companySector;
        uint256 companyStatus;
        address access;
    }

    struct jobRequests {
        address companyAddress;
        address employeeAddress;
        string companyName;
        string employeeName;
        string reasonForInvitation;
        uint32 status;
    }

    // /// // // // // // // // / /

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

    struct studentIndex {
        address clgAddr;
        uint256 index;
    }

    mapping(address => uint256) internal collegeIndex;
    mapping(address => uint256) internal companyIndex;

    mapping(address => mapping(uint256 => student[])) internal studentDetails;
    mapping(address => mapping(uint256 => student2[])) internal studentDetails2;
    mapping(address => college[]) internal collegeDetails;
    mapping(address => bool) internal CollegeAddress;
    mapping(address => bool) internal CompanyAddress;
    mapping(address => uint256) internal colReq;
    mapping(address => studentIndex[]) internal studIndex;
    mapping(address => uint256) internal userID;

    // // // // // // // // //
    // company mappings
    // // // // // // // // //

    mapping(bytes32 => mapping(address => bool)) internal Roles;
    mapping(address => mapping(uint256 => employee[])) internal employeeCert;
    mapping(address => company[]) internal companyDetails;
    mapping(address => jobRequests[]) internal jobInvites;
    mapping(address => string) internal waiting;
    mapping(address => address[]) internal companyReqs;

    bytes32 internal constant COLLEGE = keccak256(abi.encodePacked("COLLEGE"));
    bytes32 internal constant COMPANY = keccak256(abi.encodePacked("COMPANY"));
    bytes32 internal constant STUDENT = keccak256(abi.encodePacked("STUDENT"));
    bytes32 internal constant RETRIEVER =
        keccak256(abi.encodePacked("RETRIEVER"));

    modifier onlyRole(bytes32 _role) {
        require(Roles[_role][msg.sender], " Not Authorized");
        _;
    }

    function GrantRole(bytes32 _role, address _account) internal onlyOwner {
        Roles[_role][_account] = true;
    }

    function checkAddress(address _account)
        public
        view
        returns (string memory)
    {
        if (
            Roles[
                0xc951d7098b66ba0b8b77265b6e9cf0e187d73125a42bcd0061b09a68be421810
            ][_account]
        ) {
            return ("STUDENT");
        } else if (
            Roles[
                0x6b930a54bc9a8d9d32021a28e2282ffedf33210754271fcab1eb90abc2021a1c
            ][_account]
        ) {
            return ("COMPANY");
        } else if (
            Roles[
                0x112ca87938ff9caa27257dbd0ca0f4fabbcf5fd4948bc02864cc3fbce825277f
            ][_account]
        ) {
            return ("COLLEGE");
        } else {
            return ("NONE");
        }
    }

    function walletReg() public view returns (string memory) {
        return (waiting[msg.sender]);
    }
}
