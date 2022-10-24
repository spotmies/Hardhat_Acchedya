module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("Deploying College Contract...");

  const RegistrationsContract = await ethers.getContractFactory(
    "Registrations"
  );
  const RegistrationsContractProxy = await upgrades.deployProxy(
    RegistrationsContract,
    [],
    {
      kind: "uups",
      initializer: "initialize",
    }
  );

  // // const RegistrationsContract = await upgrades.deployProxy(RegistrationsContract, [], {
  // //   initializer: "initialize",
  // // });
  await RegistrationsContractProxy.deployed();
  log(
    "Deployed College contract version 1 to:",
    RegistrationsContractProxy.address
  );

  // const RegistrationsContractV2 = await ethers.getContractFactory(
  //   "CollegeContractV3"
  // );
  // const upgraded = await upgrades.upgradeProxy(
  //   "0x790bF616BF7E5ab91e6c3209b389906eef6a5766",
  //   CollegeContractV2,
  //   { kind: "uups", call: "initialize" }
  // );
  // console.log(
  //   `College Contract V2 is upgraded in proxy address: ${upgraded.address}`
  // );

  // await upgraded.deployed();
  // const newVersion = await upgraded.version();
  // log("version deployed:", newVersion);
};
