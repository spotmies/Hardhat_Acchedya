// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./variables.sol";

error YOU_ARE_NOT_AUTHORIZED_TO_UPDATE();
error STUDENT_ALREADY_EXIST();
error YOUR_PROFILE_VERIFICATION_PENDING();

///  @title Acchedya College/Student Contract
/// @author Hemanth Veeranala
/// @notice This contract is used to store/update/retrieve the student details and college details
/// @dev Go through the resources mentioned in the Docs folder before making any changes to the contract. This is a UUPS upgradable contract, so it is better to understand how upgrades work in solidity before making changes.

contract CollegeContract is Ownable, variables {
    // function Add_Student_Certificates_by_onlyCollege(
    //     address _studentAddress,
    //     string memory _collegename,
    //     string memory _studentId,
    //     string memory _name,
    //     string memory _year,
    //     string memory _course,
    //     string memory _rollNo,
    //     string memory _doj,
    //     string[] memory _certs,
    //     string[] memory _certNames,
    //     string memory _certType
    // ) public {
    //     studentIndex[] memory index_Array = get_student_Index(_studentAddress);
    //     if (index_Array.length != 0) {
    //         for (i = 0; i <= index_Array.length; i++) {
    //             if (index_Array[i].clgAddr == msg.sender) {
    //                 studentDetails[msg.sender][index_Array[0].index][0]
    //                     .collegeName = _collegename;
    //                 studentDetails[msg.sender][index_Array[0].index][0]
    //                     .ID = _studentId;
    //                 studentDetails[msg.sender][index_Array[0].index][0]
    //                     .name = _name;
    //                 studentDetails[msg.sender][index_Array[0].index][0]
    //                     .year = _year;
    //                 studentDetails[msg.sender][index_Array[0].index][0]
    //                     .course = _course;
    //                 studentDetails[msg.sender][index_Array[0].index][0]
    //                     .rollNo = _rollNo;
    //                 studentDetails[msg.sender][index_Array[0].index][0]
    //                     .DOJ = _doj;
    //                 studentDetails[msg.sender][index_Array[0].index][0]
    //                     .certs = _certs;
    //                 studentDetails[msg.sender][index_Array[0].index][0]
    //                     .certName = _certNames;
    //                 studentDetails[msg.sender][index_Array[0].index][0]
    //                     .certType = _certType;
    //             }
    //         }
    //     } else {
    //         // Remove below equation before testing, look at returned_Value function before removing this equation
    //         colReq[msg.sender] = colReq[msg.sender] + 1;
    //         Roles[
    //             0xc951d7098b66ba0b8b77265b6e9cf0e187d73125a42bcd0061b09a68be421810
    //         ][_studentAddress] = true;
    //         /*
    //          * Replace colReq[] mapping with studentDetails.length() before testing
    //          */
    //         studIndex[_studentAddress].push(
    //             studentIndex(msg.sender, colReq[msg.sender])
    //         );
    //         studentDetails[msg.sender][colReq[msg.sender]].push(
    //             student(
    //                 _collegename,
    //                 _studentId,
    //                 _name,
    //                 _year,
    //                 _course,
    //                 _rollNo,
    //                 _doj,
    //                 _certs,
    //                 _certNames,
    //                 _certType,
    //                 block.timestamp,
    //                 "COLLEGE",
    //                 msg.sender,
    //                 3
    //             )
    //         );
    //     }
    // }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    // COLLEGE SECTION
    ///////////////////////////////////////////////////////////////////////////////////////////////

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
                    msg.sender
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
        studentDetails[msg.sender][colReq[_clgAddress]][0].verified = _verified;
    }

    /// @notice This function is used to add student certificates and students/colleges can call this function (onlyRole modifier might not appear during testing).
    /// @notice Do not get confused with add student function.
    /// @notice The structs below student & student2 are intentionally seperated to avoid stack too deep error. Do not merge them into a single struct in future.

    function Add_Student_Certificates(
        address _collegeAddr,
        address _studentWalletAddress,
        student memory studentStruct,
        student2 memory studentStruct2
    ) public {
        studentIndex[] memory index_Array = get_student_Index(
            _studentWalletAddress
        );
        uint256 i;
        address collegeAddr;
        for (i = 0; i <= index_Array.length; i++) {
            if (index_Array[i].clgAddr == _collegeAddr) {
                collegeAddr = _collegeAddr;
            }
        }
        if (collegeAddr != _collegeAddr) {
            // Remove below equation before testing if it is not required, look at returned_Value function before removing this equation
            uint256 collegeCount = colReq[collegeAddr] + 1;
            string memory _role = checkAddress(msg.sender);
            if (
                keccak256(abi.encodePacked(_role)) ==
                keccak256(abi.encodePacked("STUDENT"))
            ) {
                waiting[_studentWalletAddress] = "STUDENT_WAITING";
            } else if (
                keccak256(abi.encodePacked(_role)) ==
                keccak256(abi.encodePacked("COLLEGE"))
            ) {
                Roles[
                    0xc951d7098b66ba0b8b77265b6e9cf0e187d73125a42bcd0061b09a68be421810
                ][_studentWalletAddress] = true;
            }
            /*
             * Replace colReq[] mapping with studentDetails.length() before testing and check whether colReq[] mapping can be removed to save some gas.
             */
            studIndex[msg.sender].push(studentIndex(collegeAddr, collegeCount));
            studentDetails[collegeAddr][collegeCount].push(
                student(
                    studentStruct.certs,
                    studentStruct.certName,
                    studentStruct.certType,
                    block.timestamp,
                    studentStruct.AddedBy,
                    studentStruct.collegeAdd,
                    studentStruct.verified
                )
            );
            studentDetails2[collegeAddr][collegeCount].push(
                student2(
                    studentStruct2.collegeName,
                    studentStruct2.ID,
                    studentStruct2.name,
                    studentStruct2.year,
                    studentStruct2.course,
                    studentStruct2.rollNo,
                    studentStruct2.DOJ
                )
            );
        } else {
            revert STUDENT_ALREADY_EXIST();
        }
    }

    /// @notice This function is used to update student certificates and students/colleges can call this function (onlyRole modifier might not appear during testing).
    /// @notice The structs below student & student2 are intentionally seperated to avoid stack too deep error. Do not merge them into a single struct in future.

    function update_student_certificates(
        address _collegeAddr,
        address _studentWalletAddress,
        student2 memory studentStruct,
        string[] memory _certs,
        string[] memory _certNames,
        string memory _certType
    ) public {
        studentIndex[] memory index_Array = get_student_Index(
            _studentWalletAddress
        );
        string memory _role = checkAddress(msg.sender);
        address college = _collegeAddr;
        if (index_Array.length != 0 && index_Array[0].clgAddr == college) {
            if (
                keccak256(abi.encodePacked(_role)) !=
                keccak256(abi.encodePacked("STUDENT")) ||
                keccak256(abi.encodePacked(_role)) ==
                keccak256(abi.encodePacked("COLLEGE"))
            ) {
                studentDetails2[college][index_Array[0].index][0]
                    .collegeName = studentStruct.collegeName;
                studentDetails2[college][index_Array[0].index][0]
                    .ID = studentStruct.ID;
                studentDetails2[college][index_Array[0].index][0]
                    .name = studentStruct.name;
                studentDetails2[college][index_Array[0].index][0]
                    .year = studentStruct.year;
                studentDetails2[college][index_Array[0].index][0]
                    .course = studentStruct.course;
                studentDetails2[college][index_Array[0].index][0]
                    .rollNo = studentStruct.rollNo;
                studentDetails2[college][index_Array[0].index][0]
                    .DOJ = studentStruct.DOJ;
                studentDetails[college][index_Array[0].index][0].certs = _certs;
                studentDetails[college][index_Array[0].index][0]
                    .certName = _certNames;
                studentDetails[college][index_Array[0].index][0]
                    .certType = _certType;
            }
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
        returns (student[] memory, student2[] memory)
    {
        return (
            studentDetails[_collegeAddr][_colReq],
            studentDetails2[_collegeAddr][_colReq]
        );
    }

    function total_students_for_college() public view returns (uint256) {
        return (colReq[msg.sender]);
    }

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
}
