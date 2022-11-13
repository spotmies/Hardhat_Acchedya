// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/access/Ownable.sol";
import "../variables.sol";
import "./companyVariables.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

error YOUR_PROFILE_VERIFICATION_PENDING();
error YOU_ARE_NOT_AUTHORIZED_TO_UPDATE();
error You_are_not_the_owner();
error You_Cannot_Access_The_Data();

/// @title Acchedya College/Student Contract
/// @author Hemanth Veeranala
/// @notice This contract is used to store/update/retrieve the student details and college details
/// @dev Go through the resources mentioned in the Docs folder before making any changes to the contract. This is a UUPS upgradable contract, so it is better to understand how upgrades work in solidity before making changes.

contract CompanyContract is variables, CompanyVariables, UUPSUpgradeable {
    function initialize() public initializer {
        ///@dev as there is no constructor, we need to initialise the OwnableUpgradeable explicitly
        __Ownable_init();
    }

    ///@dev required by the OZ UUPS module
    function _authorizeUpgrade(address) internal override onlyOwner {}

    // // // // // //
    // COMPANY SECTION
    // // // // // //

    function AddEmployeeCert(
        address _studentAddress,
        address _companyAddress,
        string memory _joiningDate,
        string memory _leftDate,
        string memory _designation,
        string[] memory _certs,
        string[] memory _certNames,
        string memory _certType
    ) public {
        string memory _role = checkAddress(msg.sender);
        uint32 _verify;

        if (
            keccak256(abi.encodePacked(_role)) !=
            keccak256(abi.encodePacked("STUDENT"))
        ) {
            _verify = 1;
            xpCerts[_companyAddress].push(_studentAddress);
        } else if (
            keccak256(abi.encodePacked(_role)) ==
            keccak256(abi.encodePacked("COMPANY"))
        ) {
            _verify = 2;
        }

        if (
            keccak256(abi.encodePacked(_role)) !=
            keccak256(abi.encodePacked("STUDENT")) ||
            keccak256(abi.encodePacked(_role)) ==
            keccak256(abi.encodePacked("COMPANY"))
        ) {
            employeeCert[_studentAddress][0].push(
                employee(
                    _joiningDate,
                    _leftDate,
                    _designation,
                    block.timestamp,
                    _certs,
                    _certNames,
                    _certType,
                    _role,
                    _companyAddress,
                    _verify
                )
            );
        } else {
            revert YOU_ARE_NOT_AUTHORIZED_TO_UPDATE();
        }
    }

    // Companies will already have access to their employees data. They list unverified employee certs and the company admin verifies them.

    function verifyXpCert(address _studentAddress) public {
        employeeCert[_studentAddress][0][0].verified = 2;
    }

    function update_employee_cert(
        address _studentAddress,
        address _companyAddress,
        string memory _joiningDate,
        string memory _leftDate,
        string memory _designation,
        string[] memory _certs,
        string[] memory _certNames,
        string memory _certType
    ) public {
        string memory _role = checkAddress(msg.sender);
        uint32 _verify;

        if (
            keccak256(abi.encodePacked(_role)) !=
            keccak256(abi.encodePacked("STUDENT"))
        ) {
            _verify = 1;
        } else if (
            keccak256(abi.encodePacked(_role)) ==
            keccak256(abi.encodePacked("COMPANY"))
        ) {
            _verify = 2;
        }

        if (
            keccak256(abi.encodePacked(_role)) !=
            keccak256(abi.encodePacked("STUDENT")) ||
            keccak256(abi.encodePacked(_role)) ==
            keccak256(abi.encodePacked("COMPANY"))
        ) {
            employeeCert[_studentAddress][0][0].joiningDate = _joiningDate;
            employeeCert[_studentAddress][0][0].leftDate = _leftDate;
            employeeCert[_studentAddress][0][0].designation = _designation;
            employeeCert[_studentAddress][0][0].timestamp = block.timestamp;
            employeeCert[_studentAddress][0][0].certs = _certs;
            employeeCert[_studentAddress][0][0].certName = _certNames;
            employeeCert[_studentAddress][0][0].certType = _certType;
            employeeCert[_studentAddress][0][0].AddedBy = _role;
            employeeCert[_studentAddress][0][0].companyAdd = _companyAddress;
            employeeCert[_studentAddress][0][0].verified = _verify;
        } else {
            revert YOU_ARE_NOT_AUTHORIZED_TO_UPDATE();
        }
    }

    /// @notice This function is used to verify employee certificates and only companies can call this function (onlyRole modifier might not be appeared during testing phase).
    /// @param _verified: 1 for pending, 2 for verified, 3 for rejected

    function employeeCertVerified(address _collegeAddr, uint32 _verified)
        public
    {
        employeeCert[_collegeAddr][0][0].verified = _verified;
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
                "",
                1
            )
        );
    }

    function Accept_company_req(
        uint32 _index,
        uint32 inviStatus,
        string memory _companyKey
    ) public {
        jobInvites[msg.sender][_index].companyKey = _companyKey;
        jobInvites[msg.sender][_index].status = inviStatus;
    }

    ////////////////////////////////////////////////////////
    //// VIEW FUNCTIONS
    ////////////////////////////////////////////////////////

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
                if (msg.sender != jobInvites[studAddr][i].companyAddress) {
                    revert You_Cannot_Access_The_Data();
                }
                companyInvi[i] = jobInvites[studAddr][i];
            } else {
                companyInvi[i] = jobInvites[studAddr][i];
            }
        }

        return (companyInvi);
    }
}
