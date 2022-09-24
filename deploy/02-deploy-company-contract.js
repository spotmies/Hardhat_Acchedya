module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("Deploying Company contract...");

  const CompanyContract = await deploy("CompanyContract", {
    from: deployer,
    args: [],
    log: true,
  });
  log("Deployed company contract to:", CompanyContract.address);
};
