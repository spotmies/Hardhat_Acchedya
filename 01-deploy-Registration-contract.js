module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("Deploying Registration Contract...");

  // const RegistrationsContract = await ethers.getContractFactory(
  //   "Registrations"
  // );
  // const RegistrationsContractProxy = await upgrades.deployProxy(
  //   RegistrationsContract,
  //   [],
  //   {
  //     kind: "uups",
  //     initializer: "initialize",
  //   }
  // );

  // await RegistrationsContractProxy.deployed();
  // log(
  //   "Deployed Registrations contract to:",
  //   RegistrationsContractProxy.address
  // );

  const RegistrationsContract = await ethers.getContractFactory(
    "Registrations"
  );
  const upgraded = await upgrades.upgradeProxy(
    "0xC4a21B522521bcd302B6910BD6E4F2AbE7701e0d",
    RegistrationsContract,
    { kind: "uups", call: "initialize" }
  );
  console.log(
    `College Contract V2 is upgraded in proxy address: ${upgraded.address}`
  );

  // await upgraded.deployed();
  // const newVersion = await upgraded.version();
  // log("version deployed:", newVersion);
};
