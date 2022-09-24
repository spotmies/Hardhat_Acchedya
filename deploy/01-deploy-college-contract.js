module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("Deploying College Contract...");

  const CollegeContract = await deploy("CollegeContract", {
    from: deployer,
    args: [],
    log: true,
  });
  log("Deployed College contract to:", CollegeContract.address);
};
