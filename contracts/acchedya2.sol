// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./variables.sol";

contract Acchedya2 is Ownable, variables {
    // // // // // //
    // COMPANY SECTION
    // // // // // //

    function AddCompany(
        address _companyAddr,
        string memory _companyName,
        string memory _address,
        string memory _phone,
        string memory _email,
        string memory _sector,
        uint32 _status
    ) public {
        address companyWalletAddres = _companyAddr;
        address theOwner = owner();
        waiting[msg.sender] = "COMPANY_WAITING";
        companyDetails[theOwner].push(
            company(
                companyWalletAddres,
                _companyName,
                _address,
                _phone,
                _email,
                _sector,
                _status,
                msg.sender
            )
        );
    }

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
                require(msg.sender == owner(), "you are not the owner");
                companyDet[i] = companyDetails[theOwner][i];
            }
        }
        return (companyDet);
    }

    function AddEmployeeCert(
        address _studentAddress,
        string memory _joiningDate,
        string memory _leftDate,
        string memory _designation,
        string[] memory _certs,
        string[] memory _certNames,
        string memory _certType
    ) public {
        employeeCert[_studentAddress][0].push(
            employee(
                _joiningDate,
                _leftDate,
                _designation,
                block.timestamp,
                _certs,
                _certNames,
                _certType,
                "COMPANY",
                msg.sender,
                3
            )
        );
    }

    function employeeCertVerified(address _collegeAddr, uint32 _verified)
        public
    {
        employeeCert[_collegeAddr][0][0].verified = _verified;
    }

    function AddEmpCertself(
        address _studentAddress,
        string memory _joiningDate,
        string memory _leftDate,
        string memory _designation,
        string[] memory _certs,
        string[] memory _certNames,
        string memory _certType
    ) public {
        address studentAdd = _studentAddress;
        employeeCert[studentAdd][0].push(
            employee(
                _joiningDate,
                _leftDate,
                _designation,
                block.timestamp,
                _certs,
                _certNames,
                _certType,
                "EMPLOYEE",
                msg.sender,
                1
            )
        );
    }

    function getEmpDet(address _studentAddr)
        public
        view
        returns (employee[] memory)
    {
        return (employeeCert[_studentAddr][0]);
    }

    function sendInvitation(
        address _employeeAddr,
        string memory _employeeName,
        string memory _companyName,
        string memory _reasonForInvitation
    ) public {
        companyReqs[msg.sender].push(_employeeAddr);
        jobInvites[_employeeAddr].push(
            jobRequests(
                msg.sender,
                _employeeAddr,
                _employeeName,
                _companyName,
                _reasonForInvitation,
                1
            )
        );
    }

    function updateStatus(uint32 _index, uint32 inviStatus) public {
        jobInvites[msg.sender][_index].status = inviStatus;
    }

    function getEmpAddr() public view returns (address[] memory) {
        return (companyReqs[msg.sender]);
    }

    function getInvitations(address studAddr)
        public
        view
        returns (jobRequests[] memory)
    {
        uint i;
        uint256 len = jobInvites[studAddr].length;
        jobRequests[] memory companyInvi = new jobRequests[](len);

        for (i = 0; i < len; i++) {
            if (msg.sender == jobInvites[studAddr][i].companyAddress) {
                require(
                    msg.sender == jobInvites[studAddr][i].companyAddress,
                    "You cannot Access the data"
                );
                companyInvi[i] = jobInvites[studAddr][i];
            } else {
                companyInvi[i] = jobInvites[studAddr][i];
            }
        }

        return (companyInvi);
    }
}
