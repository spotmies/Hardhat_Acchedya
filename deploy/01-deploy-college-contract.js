module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("Deploying College Contract...");

  const CollegeContract = await ethers.getContractFactory("CollegeContract");
  const CollegeContractProxy = await upgrades.deployProxy(CollegeContract, [], {
    kind: "uups",
    initializer: "initialize",
  });

  // const CollegeContract = await upgrades.deployProxy(CollegeContract, [], {
  //   initializer: "initialize",
  // });
  await CollegeContractProxy.deployed();
  log("Deployed College contract to:", CollegeContractProxy.address);
};
