// We import Chai to use its asserting functions here.
const { expect } = require("chai");


describe("Trade Contract", function () {

    let CarsTrade;
    let carsTrade;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    beforeEach(async function () {
        // Get the ContractFactory and Signers here.
        CarsTrade = await ethers.getContractFactory("TradeCars");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    
        // To deploy our contract, we just have to call CarsTrade.deploy() and await
        // for it to be deployed(), which happens once its transaction has been
        // mined.

        console.log("Addr 1 " , addr1);
        carsTrade = await CarsTrade.deploy("Cars","CRS");

    });

    it("Trade - Get collection name - should return Cars", async function () {
        const _name = await carsTrade.name();
        expect("Cars").to.equal(_name);

    });



    it("Trade - Get collection symbol - should return CRS", async function () {
        const _symbol = await carsTrade.symbol();
        expect("CRS").to.equal(_symbol);

    });

    // it("Mint function should return /xyzTestPathToNFT as token URI", async function () {

    //     await carsMint.MintCarsNFT("/xyzTestPathToNFT" , 3000000);
    //     const _tokenURI = await carsMint.tokenURI(0);
    //     expect("/xyzTestPathToNFT").to.equal(_tokenURI);

    // });

        // it("Should return buyer address ", async function () {

        // await carsTrade.MintCarsNFT("/xyzTestPathToNFT" , 3000000);

        // await carsTrade.connect(addr1).BuyCarsNFT(0);

        // const _newOwner = await carsTrade.ownerof(0); 
        // expect(addr1).to.equal(_newOwner); // should be equal to buyer address 

        // });





});

