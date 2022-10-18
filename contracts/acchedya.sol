// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./variables.sol";

contract Acchedya is Ownable, variables {
    // // // // // //
    // STUDENT SECTION
    // // // // // //

    function getstudIndex(address _studAddr)
        public
        view
        returns (studentIndex[] memory)
    {
        return (studIndex[_studAddr]);
    }

    function AddStudent(
        address _studentAddress,
        string memory _collegename,
        string memory _studentId,
        string memory _name,
        string memory _year,
        string memory _course,
        string memory _rollNo,
        string memory _doj,
        string[] memory _certs,
        string[] memory _certNames,
        string memory _certType
    ) public {
        colReq[msg.sender] = colReq[msg.sender] + 1;
        Roles[
            0xc951d7098b66ba0b8b77265b6e9cf0e187d73125a42bcd0061b09a68be421810
        ][_studentAddress] = true;
        studIndex[_studentAddress].push(
            studentIndex(msg.sender, colReq[msg.sender])
        );
        studentDetails[msg.sender][colReq[msg.sender]].push(
            student(
                _collegename,
                _studentId,
                _name,
                _year,
                _course,
                _rollNo,
                _doj,
                _certs,
                _certNames,
                _certType,
                block.timestamp,
                "COLLEGE",
                msg.sender,
                3
            )
        );
    }

    function studentVerified(
        address _clg,
        address _studentAddress,
        uint32 _verified
    ) public {
        Roles[
            0xc951d7098b66ba0b8b77265b6e9cf0e187d73125a42bcd0061b09a68be421810
        ][_studentAddress] = true;
        studentDetails[msg.sender][colReq[_clg]][0].verified = _verified;
    }

    function AddStudentself(
        address _collegeAddr,
        string memory _collegename,
        string memory _studentId,
        string memory _name,
        string memory _year,
        string memory _course,
        string memory _rollNo,
        string memory _doj,
        string[] memory _certs,
        string[] memory _certNames,
        string memory _certType
    ) public {
        colReq[_collegeAddr] = colReq[_collegeAddr] + 1;
        waiting[msg.sender] = "STUDENT_WAITING";
        studIndex[msg.sender].push(
            studentIndex(_collegeAddr, colReq[_collegeAddr])
        );
        studentDetails[_collegeAddr][colReq[_collegeAddr]].push(
            student(
                _collegename,
                _studentId,
                _name,
                _year,
                _course,
                _rollNo,
                _doj,
                _certs,
                _certNames,
                _certType,
                block.timestamp,
                "STUDENT",
                _collegeAddr,
                1
            )
        );
    }

    function getStudentSelf(address _collegeAddr, uint256 _colReq)
        public
        view
        returns (student[] memory)
    {
        return (studentDetails[_collegeAddr][_colReq]);
    }

    function reurnedVale() public view returns (uint256) {
        return (colReq[msg.sender]);
    }

    // // // // // //
    // COLLEGE SECTION
    // // // // // //

    function AddCollege(
        address _collegeAddr,
        string memory _collegeName,
        string memory _address,
        string memory _phone,
        string memory _email,
        uint32 _status
    ) public {
        address collegeWalletAddres = _collegeAddr;
        address theOwner = owner();
        waiting[msg.sender] = "COLLEGE_WAITING";
        collegeDetails[theOwner].push(
            college(
                collegeWalletAddres,
                _collegeName,
                _address,
                _phone,
                _email,
                _status,
                msg.sender
            )
        );
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
}
