// We import Chai to use its asserting functions here.
const { expect } = require("chai");


describe("Mint Contract", function () {

    let CarsMint;
    let carsMint;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    beforeEach(async function () {
        // Get the ContractFactory and Signers here.
        CarsMint = await ethers.getContractFactory("MintCars");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    
        // To deploy our contract, we just have to call CarsMint.deploy() and await
        // for it to be deployed(), which happens once its transaction has been
        // mined.

        carsMint = await CarsMint.deploy("Cars","CRS");

    });

    it("Get collection name - should return Cars", async function () {
        const _name = await carsMint.name();
        expect("Cars").to.equal(_name);

    });



    it("Get collection symbol - should return CRS", async function () {
        const _symbol = await carsMint.symbol();
        expect("CRS").to.equal(_symbol);

    });

    it("Mint function should return /xyzTestPathToNFT as token URI", async function () {

        await carsMint.MintCarsNFT("/xyzTestPathToNFT" , 3000000);
        const _tokenURI = await carsMint.tokenURI(0);
        expect("/xyzTestPathToNFT").to.equal(_tokenURI);

    });


});

