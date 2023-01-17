module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("Deploying College Contract...");

  const CollegeContract = await ethers.getContractFactory("College_Contract");
  const upgraded = await upgrades.upgradeProxy(
    "0x4377b3C95E5f15b4b162135403A0eca1e34b36Af",
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
