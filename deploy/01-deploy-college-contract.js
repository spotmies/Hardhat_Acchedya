const { verify } = require("../hardhat.config");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("Deploying College Contract...");

  const CollegeContract = await ethers.getContractFactory("Acchedya");
  const CollegeContractProxy = await CollegeContract.deploy();
  await CollegeContractProxy.deployed();
  log("College Contract deployed to:", CollegeContractProxy.address);

  await CollegeContractProxy.deployTransaction.wait(6);
  await verifying(CollegeContractProxy.address, []);
  console.log("College contract verified");
};

async function verifying(contractAddress, args) {
  console.log("Verifying contract...");
  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    });
  } catch (e) {
    if (e.message.includes("Contract source code already verified")) {
      console.log("Contract source code already verified");
    } else {
      console.log(e.message);
    }
  }
}
