module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("Deploying College Contract...");

  // const CollegeContract = await ethers.getContractFactory("College_Contract");
  // const CollegeContractProxy = await upgrades.deployProxy(CollegeContract, [], {
  //   kind: "uups",
  //   initializer: "initialize",
  // });

  // await CollegeContractProxy.deployed();
  // log("Deployed College contract version 2 to:", CollegeContractProxy.address);

  const CollegeContract = await ethers.getContractFactory("College_Contract");
  const upgraded = await upgrades.upgradeProxy(
    "0x557c5274308041Ba590FC3327ADc6B3E231A552c",
    CollegeContract,
    { kind: "uups", call: "initialize" }
  );
  console.log(
    `College Contract V2 is upgraded in proxy address: ${upgraded.address}`
  );

  // await upgraded.deployed();
  // const newVersion = await upgraded.version();
  // log("version deployed:", newVersion);
};
