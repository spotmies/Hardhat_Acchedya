// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title Acchedya College/Student Contract
/// @author Hemanth Veeranala
/// @notice This contract is used to store/update/retrieve the student details and college details
/// @dev Go through the resources mentioned in the Docs folder before making any changes to the contract. This is a UUPS upgradable contract, so it is better to understand how upgrades work in solidity before making changes.

contract variables is OwnableUpgradeable {
    using SafeMath for uint;
    using SafeMath for uint32;
    using SafeMath for uint256;

    struct studentIndex {
        address clgAddr;
        uint256 index;
    }

    struct reserved {
        string reserved1;
        string reserved2;
        string reserved3;
        string reserved4;
    }

    mapping(address => studentIndex[]) internal studIndex;
    // mapping(address => uint256) internal userID;

    // // // // // // // // //
    // common mappings
    // // // // // // // // //
    mapping(address => string) internal waiting;

    mapping(bytes32 => mapping(address => bool)) internal Roles;

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

    function checkAddress(
        address _account
    ) public view returns (string memory) {
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
