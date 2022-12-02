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

  //   const CompanyContract = await ethers.getContractFactory("CompanyContract");
  //   const upgraded = await upgrades.upgradeProxy(
  //     "0xAe94CE39A17ff8A64A48100C56a2b848E585639F",
  //     CompanyContract,
  //     { kind: "uups", call: "initialize" }
  //   );
  //   console.log(
  //     `College Contract V2 is upgraded in proxy address: ${upgraded.address}`
  //   );
};
