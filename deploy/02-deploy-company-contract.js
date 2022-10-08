module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("Deploying Company contract...");

  const CompanyContract = await ethers.getContractFactory("CompanyContract");
  const CompanyContractProxy = await upgrades.deployProxy(CompanyContract, [], {
    kind: "uups",
    initializer: "initialize",
  });
  await CompanyContractProxy.deployed();
  log("Deployed company contract to:", CompanyContractProxy.address);
};
