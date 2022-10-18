// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract variables is Ownable {
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
        string companyAddres;
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
        string collegeName;
        string ID;
        string name;
        string year;
        string course;
        string rollNo;
        string DOJ;
        string[] certs;
        string[] certName;
        string certType;
        uint256 timestamp;
        string AddedBy;
        address collegeAdd;
        uint32 verified;
    }

    struct college {
        address collegeWalAddress;
        string collegeName;
        string collegeAddres;
        string collegePhone;
        string collegeEmail;
        uint32 collegeStatus;
        address access;
    }

    struct studentIndex {
        address clgAddr;
        uint256 index;
    }

    mapping(address => mapping(uint256 => student[])) studentDetails;
    mapping(address => college[]) collegeDetails;
    mapping(address => bool) public CollegeAddress;
    mapping(address => bool) public CompanyAddress;
    mapping(address => uint256) colReq;
    mapping(address => studentIndex[]) studIndex;
    mapping(address => uint256) userID;

    // // // // // // // // //
    // company mappings
    // // // // // // // // //

    mapping(bytes32 => mapping(address => bool)) public Roles;
    mapping(address => mapping(uint256 => employee[])) employeeCert;
    mapping(address => company[]) companyDetails;
    mapping(address => jobRequests[]) jobInvites;
    mapping(address => string) waiting;
    mapping(address => address[]) companyReqs;

    bytes32 public constant COLLEGE = keccak256(abi.encodePacked("COLLEGE"));
    bytes32 public constant COMPANY = keccak256(abi.encodePacked("COMPANY"));
    bytes32 public constant STUDENT = keccak256(abi.encodePacked("STUDENT"));
    bytes32 public constant RETRIEVER =
        keccak256(abi.encodePacked("RETRIEVER"));

    modifier onlyRole(bytes32 _role) {
        require(Roles[_role][msg.sender], " Not Authorized");
        _;
    }

    function GrantRole(bytes32 _role, address _account) public onlyOwner {
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
