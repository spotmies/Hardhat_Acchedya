module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("Deploying College Contract...");

  // const CollegeContract = await ethers.getContractFactory("CollegeContractV4");
  // const CollegeContractProxy = await upgrades.deployProxy(CollegeContract, [], {
  //   kind: "uups",
  //   initializer: "initialize",
  // });

  // // const CollegeContract = await upgrades.deployProxy(CollegeContract, [], {
  // //   initializer: "initialize",
  // // });
  // await CollegeContractProxy.deployed();
  // log("Deployed College contract version 1 to:", CollegeContractProxy.address);

  const CollegeContractV2 = await ethers.getContractFactory(
    "CollegeContractV3"
  );
  const upgraded = await upgrades.upgradeProxy(
    "0x790bF616BF7E5ab91e6c3209b389906eef6a5766",
    CollegeContractV2,
    { kind: "uups", call: "initialize" }
  );
  console.log(
    `College Contract V2 is upgraded in proxy address: ${upgraded.address}`
  );

  await upgraded.deployed();
  const newVersion = await upgraded.version();
  log("version deployed:", newVersion);
};
