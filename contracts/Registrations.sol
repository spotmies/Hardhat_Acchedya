// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/access/Ownable.sol";
import "./variables.sol";
import "./College/CollegeVariables.sol";
import "./Company/companyVariables.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

error YOU_ARE_NOT_AUTHORIZED_TO_UPDATE();
error STUDENT_ALREADY_EXIST();
error YOUR_PROFILE_VERIFICATION_PENDING();
error You_are_not_the_owner();

///////////////////////////////////////////////////////////////////////////////////////////////
// COLLEGE SECTION
///////////////////////////////////////////////////////////////////////////////////////////////

///  @title Acchedya College/Student Contract
/// @author Hemanth Veeranala
/// @notice This contract is used to store/update/retrieve the student details and college details
/// @dev Go through the resources mentioned in the Docs folder before making any changes to the contract. This is a UUPS upgradable contract, so it is better to understand how upgrades work in solidity before making changes.

contract Registrations is
    variables,
    CollegeVariables,
    CompanyVariables,
    UUPSUpgradeable
{
    function initialize() public reinitializer(2) {
        ///@dev as there is no constructor, we need to initialise the OwnableUpgradeable explicitly
        __Ownable_init();
    }

    ///@dev required by the OZ UUPS module
    function _authorizeUpgrade(address) internal override onlyOwner {}

    /// @notice  This function is used to add a college to the contract.
    /// @param _collegeAddr wallet address of the college
    /// @param _address physical address of the college

    function Add_College(
        address _collegeAddr,
        string memory _collegeName,
        string memory _address,
        string memory _phone,
        string memory _email,
        uint32 _status
    ) public {
        address collegeWalletAddress = _collegeAddr;
        address theOwner = owner();
        uint256 index = collegeIndex[msg.sender];

        if (index == 0) {
            waiting[msg.sender] = "COLLEGE_WAITING";
            collegeIndex[collegeWalletAddress] = collegeDetails[theOwner]
                .length;
            collegeDetails[theOwner].push(
                college(
                    collegeWalletAddress,
                    _collegeName,
                    _address,
                    _phone,
                    _email,
                    _status,
                    msg.sender,
                    ""
                )
            );
        } else if (
            collegeDetails[theOwner][index].collegeStatus == 2 ||
            collegeDetails[theOwner][index].collegeStatus == 3
        ) {
            collegeDetails[theOwner][index].collegeName = _collegeName;
            collegeDetails[theOwner][index].collegeAddress = _address;
            collegeDetails[theOwner][index].collegePhone = _phone;
            collegeDetails[theOwner][index].collegeEmail = _email;
            collegeDetails[theOwner][index].collegeStatus = _status;
        } else {
            revert YOUR_PROFILE_VERIFICATION_PENDING();
        }
    }

    /// @notice  This function is used to verify college and only admin can call this function (onlyOwner modifier might not be appeared during testing phase).
    /// @param _index of the college in the collegeDetails mapping
    /// @param code 1 for pending, 2 for verified, 3 for rejected

    function verifyCollege(
        uint32 _index,
        uint32 code,
        address clgAddr
    ) public onlyOwner {
        collegeDetails[msg.sender][_index].collegeStatus = code;
        //grant role
        GrantRole(
            0x112ca87938ff9caa27257dbd0ca0f4fabbcf5fd4948bc02864cc3fbce825277f,
            clgAddr
        );
        GrantRole(
            0x02045258af11576776f56337f0666fcac2b654a57c15c8a528e83f2b72f40eef,
            clgAddr
        );
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    // COMPANY SECTION
    ///////////////////////////////////////////////////////////////////////////////////////////////

    /// @notice This function is used to add a company to the contract.
    /// @param _companyAddr: wallet address of the company
    /// @param _address: physical address of the company

    function AddCompany(
        address _companyAddr,
        string memory _companyName,
        string memory _address,
        string memory _phone,
        string memory _email,
        string memory _sector,
        uint32 _status
    ) public {
        address companyWalletAddress = _companyAddr;
        address theOwner = owner();
        uint256 index = companyIndex[msg.sender];

        if (index == 0) {
            companyIndex[companyWalletAddress] = companyDetails[theOwner]
                .length;
            waiting[msg.sender] = "COMPANY_WAITING";
            companyDetails[theOwner].push(
                company(
                    companyWalletAddress,
                    _companyName,
                    _address,
                    _phone,
                    _email,
                    _sector,
                    _status,
                    msg.sender,
                    ""
                )
            );
        } else if (
            companyDetails[theOwner][index].companyStatus == 2 ||
            companyDetails[theOwner][index].companyStatus == 3
        ) {
            companyDetails[theOwner][index].companyName = _companyName;
            companyDetails[theOwner][index].companyAddress = _address;
            companyDetails[theOwner][index].companyPhone = _phone;
            companyDetails[theOwner][index].companyEmail = _email;
            companyDetails[theOwner][index].companySector = _sector;
            companyDetails[theOwner][index].companyStatus = _status;
            companyDetails[theOwner][index].access = msg.sender;
        } else {
            revert YOUR_PROFILE_VERIFICATION_PENDING();
        }
    }

    /// @notice This function is used to verify company and only admin can call this function (onlyOwner modifier might not be appeared during testing phase).
    /// @param _index: index of the college in the companyDetails mapping
    /// @param code: 1 for pending, 2 for verified, 3 for rejected

    function verifyCompany(
        uint256 _index,
        uint256 code,
        address cmpAddr
    ) public onlyOwner {
        companyDetails[msg.sender][_index].companyStatus = code;
        //grant role
        GrantRole(
            0x6b930a54bc9a8d9d32021a28e2282ffedf33210754271fcab1eb90abc2021a1c,
            cmpAddr
        );
        GrantRole(
            0x02045258af11576776f56337f0666fcac2b654a57c15c8a528e83f2b72f40eef,
            cmpAddr
        );
    }

    ////////////////////////////////////////////////////////
    //// VIEW FUNCTIONS
    ////////////////////////////////////////////////////////

    function getCollege() public view returns (college[] memory) {
        uint i;
        address theOwner = owner();
        uint256 len = collegeDetails[theOwner].length;
        college[] memory collegeDet = new college[](len);

        for (i = 0; i < len; i++) {
            if (msg.sender != owner()) {
                if (msg.sender == collegeDetails[theOwner][i].access) {
                    collegeDet[i] = collegeDetails[theOwner][i];
                }
            } else {
                require(msg.sender == owner(), "You are not the owner.");
                collegeDet[i] = collegeDetails[theOwner][i];
            }
        }
        return (collegeDet);
    }

    function getCompaniesToOwner() public view returns (company[] memory) {
        uint256 i;
        address theOwner = owner();
        uint256 len = companyDetails[theOwner].length;
        company[] memory companyDet = new company[](len);

        for (i = 0; i < len; i++) {
            if (msg.sender != owner()) {
                if (msg.sender == companyDetails[theOwner][i].access) {
                    companyDet[i] = companyDetails[theOwner][i];
                }
            } else {
                if (msg.sender != owner()) {
                    revert You_are_not_the_owner();
                }
                companyDet[i] = companyDetails[theOwner][i];
            }
        }
        return (companyDet);
    }
}
