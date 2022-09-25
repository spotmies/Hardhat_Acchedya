const { ethers } = require("@nomiclabs/hardhat-ethers");
const { deployments, getNamedAccounts } = require("hardhat");
const { expect } = require("chai");

describe("Student Certificates", function () {
  beforeEach(function () {
    // Deploy the contracts before each test
    return deployments.fixture();
  });

  describe("Test add student certificates functionality", function () {
    beforeEach(async function () {
      // Get the deployed contract
      var collegeContract = await ethers.getContract("CollegeContract");
      var companyContract = await ethers.getContract("CompanyContract");
      var certificate = await collegeContract.Add_Student_Certificates(
        getNamedAccounts.deployer,
        getNamedAccounts.student,
        ["B.Tech-cert", "M.Tech-cert"],
        ["CSE", "ECE"],
        "2021",
        134564560,
        "COLLEGE",
        getNamedAccounts.deployer,
        2,
        "COLLEGE NAME",
        "id",
        "hash",
        "url",
        "ipfs",
        "ipfs",
        "ROLL",
        "doj"
      );
      await certificate.wait(2);
      console.log("Certificates Added");
    });

    it("Should add student certificates", async function () {
      console.log("Certificates Added");
    });
  });

  //   it("should create a new certificate", async function () {
  //     var certificate = await expect(certificate).to.be.reverted();
  //   });
});
