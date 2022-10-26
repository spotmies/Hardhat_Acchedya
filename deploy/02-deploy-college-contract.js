module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("Deploying College Contract...");

  // const CollegeContract = await ethers.getContractFactory("College_Contract");
  // const CollegeContractProxy = await upgrades.deployProxy(CollegeContract, [], {
  //   kind: "uups",
  //   initializer: "initialize",
  // });

  // const CollegeContract = await upgrades.deployProxy(CollegeContract, [], {
  //   initializer: "initialize",
  // });
  // await CollegeContractProxy.deployed();
  // log("Deployed College contract version 2 to:", CollegeContractProxy.address);

  const CollegeContractV2 = await ethers.getContractFactory("College_Contract");
  const upgraded = await upgrades.upgradeProxy(
    "0xF4fCE12595781d6f7247A771f82E359779A10e0C",
    CollegeContractV2,
    { kind: "uups", call: "initialize" }
  );
  console.log(
    `College Contract V2 is upgraded in proxy address: ${upgraded.address}`
  );

  // await upgraded.deployed();
  // const newVersion = await upgraded.version();
  // log("version deployed:", newVersion);
};
