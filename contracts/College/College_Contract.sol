// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/access/Ownable.sol";
import "../variables.sol";
import "./CollegeVariables.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

error YOU_ARE_NOT_AUTHORIZED_TO_UPDATE();
error STUDENT_ALREADY_EXIST();
error YOUR_PROFILE_VERIFICATION_PENDING();

///  @title Acchedya College/Student Contract
/// @author Hemanth Veeranala
/// @notice This contract is used to store/update/retrieve the student details and college details
/// @dev Go through the resources mentioned in the Docs folder before making any changes to the contract. This is a UUPS upgradable contract, so it is better to understand how upgrades work in solidity before making changes.

contract College_Contract is variables, CollegeVariables, UUPSUpgradeable {
    function initialize() public initializer {
        ///@dev as there is no constructor, we need to initialise the OwnableUpgradeable explicitly
        __Ownable_init();
    }

    ///@dev required by the OZ UUPS module
    function _authorizeUpgrade(address) internal override onlyOwner {}

    function version() public pure returns (string memory) {
        return "College Version 4";
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // STUDENT SECTION
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /// @notice This function is used to verify student and only colleges can call this function (onlyRole modifier might not be called during testing phase).
    /// @param _verified code 1 for pending, 2 for verified, 3 for rejected

    function student_Verified(
        address _clgAddress,
        address _studentAddress,
        uint32 _verified
    ) public {
        Roles[
            0xc951d7098b66ba0b8b77265b6e9cf0e187d73125a42bcd0061b09a68be421810
        ][_studentAddress] = true;
        studentDetails[msg.sender][colReq[_clgAddress]][0].verifiedBy = msg
            .sender;
        studentDetails[msg.sender][colReq[_clgAddress]][0].status = _verified;
    }

    /// @notice This function is used to add student certificates and students/colleges can call this function (onlyRole modifier might not appear during testing).
    /// @notice Do not get confused with add student function.
    /// @notice The structs below student & student2 are intentionally seperated to avoid stack too deep error. Do not merge them into a single struct in future.

    function Add_Student_Certificates(
        string memory _docHash,
        address _collegeAddr,
        address _studentWalletAddress,
        string memory _docId,
        // uint32 _status,
        address[] memory _sharedTo,
        string memory _role
    ) public {
        // (address collegeAddr, uint32 _verified, string memory _role, uint256 collegeCount) = add_cert_helper(_collegeAddr, _studentWalletAddress);
        // string memory _role = waiting[msg.sender];
        uint32 _verified = 1;
        address _verifiedBy;
        // if (collegeAddr != _collegeAddr) {
        if (
            keccak256(abi.encodePacked(_role)) ==
            keccak256(abi.encodePacked("COLLEGE_WAITING"))
        ) {
            _verified = 2;
            _verifiedBy = msg.sender;
        }
        /*
         * Replace colReq[] mapping with studentDetails.length() before testing and check whether colReq[] mapping can be removed to save some gas.
         */
        // studIndex[_studentWalletAddress].push(
        //     studentIndex(collegeAddr, collegeCount)
        // );
        if (
            keccak256(abi.encodePacked(_role)) ==
            keccak256(abi.encodePacked("STUDENT_WAITING")) ||
            keccak256(abi.encodePacked(_role)) ==
            keccak256(abi.encodePacked("COLLEGE_WAITING"))
        ) {
            colReq[_collegeAddr] = colReq[_collegeAddr] + 1;
            studIndex[_studentWalletAddress].push(
                studentIndex(_collegeAddr, colReq[_collegeAddr])
            );
            studentDetails[_collegeAddr][colReq[_collegeAddr]].push(
                student(
                    _docHash,
                    _docId,
                    _verified,
                    _verifiedBy,
                    msg.sender,
                    _sharedTo,
                    ""
                )
            );
        } else {
            revert STUDENT_ALREADY_EXIST();
        }
    }

    // function add_cert_helper(
    //     address _collegeAddr,
    //     address _studentWalletAddress
    // )
    //     public
    //     returns (
    //         address,
    //         uint32,
    //         string memory,
    //         uint256
    //     )
    // {
    //     studentIndex[] memory index_Array = get_student_Index(
    //         _studentWalletAddress
    //     );
    //     uint256 i;
    //     address collegeAddr;
    //     uint32 _verified = 1;
    //     string memory _role;
    //     uint256 collegeCount;

    //     // student can have different colleges in his index array (school, intermediate, graduation, pg)
    //     for (i = 0; i <= index_Array.length; i++) {
    //         if (index_Array[i].clgAddr == _collegeAddr) {
    //             collegeAddr = _collegeAddr;
    //         }
    //     }
    //     if (collegeAddr != _collegeAddr) {
    //         // Remove below equation before testing if it is not required, look at returned_Value function before removing this equation
    //         collegeCount = colReq[collegeAddr] + 1;
    //         _role = walletReg();
    //         // change the role variable to STUDENT & COLLEGE after adding onlyRoles

    //         if (
    //             keccak256(abi.encodePacked(_role)) ==
    //             keccak256(abi.encodePacked("COLLEGE_WAITING"))
    //         ) {
    //             Roles[
    //                 0xc951d7098b66ba0b8b77265b6e9cf0e187d73125a42bcd0061b09a68be421810
    //             ][_studentWalletAddress] = true;
    //             _verified = 2;
    //         }
    //     }
    //     return (collegeAddr, _verified, _role, collegeCount);
    // }

    // function add_student_cert_helper(string memory _collegeName, string memory _ID, string memory _name, string memory _year, string memory _course, string memory _rollNo, string memory _doj) public returns(string, string, string, string, string, string) {
    //     return (_collegeName, _ID, _name, _year, _course, _rollNo, _doj);
    // }

    /// @notice This function is used to update student certificates and students/colleges can call this function (onlyRole modifier might not appear during testing).
    /// @notice The structs below student & student2 are intentionally seperated to avoid stack too deep error. Do not merge them into a single struct in future.

    function update_certificates(
        string memory _docHash,
        address _collegeAddr,
        address[] memory _sharedTo,
        string memory _role,
        uint256 _index
    ) public {
        // studentIndex[] memory index_Array = get_student_Index(
        //     _studentWalletAddress
        // );
        // string memory _role = checkAddress(msg.sender);
        address college = _collegeAddr;
        uint256 index = _index;
        uint32 _verified = 1;

        if (
            keccak256(abi.encodePacked(_role)) ==
            keccak256(abi.encodePacked("COLLEGE"))
        ) {
            _verified = 2;
        }
        // uint i;
        // uint256 certIndex;

        // for (i = 0; i <= studentDetails[college][index].length; i++) {
        //     if (studentDetails[college][index][i].certIndex == _certIndex) {
        //         certIndex = _certIndex;
        //         return;
        //     }
        // }
        // return "commented item range";
        // if (index_Array.length != 0 && index_Array[0].clgAddr == college) {
        if (
            keccak256(abi.encodePacked(_role)) ==
            keccak256(abi.encodePacked("STUDENT")) ||
            keccak256(abi.encodePacked(_role)) ==
            keccak256(abi.encodePacked("COLLEGE")) ||
            keccak256(abi.encodePacked(_role)) ==
            keccak256(abi.encodePacked("STUDENT_WAITING")) ||
            keccak256(abi.encodePacked(_role)) ==
            keccak256(abi.encodePacked("COLLEGE_WAITING"))
            // college != address(0)
        ) {
            studentDetails[college][index][0].docHash = _docHash;
            studentDetails[college][index][0].status = _verified;
            studentDetails[college][index][0].sharedTo = _sharedTo;
            // studentDetails[college][index][0].verifiedBy = _collegeAddr;
        } else {
            revert YOU_ARE_NOT_AUTHORIZED_TO_UPDATE();
        }
    }

    //////////////////////////////////////////
    ////// VIEW FUNCTIONS
    //////////////////////////////////////////

    function get_student_Index(address _studAddr)
        public
        view
        returns (studentIndex[] memory)
    {
        return (studIndex[_studAddr]);
    }

    function get_Student_Details(address _collegeAddr, uint256 _colReq)
        public
        view
        returns (student[] memory)
    {
        return (
            studentDetails[_collegeAddr][_colReq]
            // studentDetails2[_collegeAddr][_colReq]
        );
    }

    function total_students_for_college() public view returns (uint256) {
        return (colReq[msg.sender]);
    }
}
