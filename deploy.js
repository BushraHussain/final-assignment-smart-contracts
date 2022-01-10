async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    //console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const Dealership = await ethers.getContractFactory("TradeCars");
    const _dealership = await Dealership.deploy("Cars","CRS");
  
    console.log("Dealership Contract address:", _dealership.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });