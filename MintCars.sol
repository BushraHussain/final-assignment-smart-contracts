// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


/**
 * @dev Contract module provides mechanism for NFT Minting for users, 
 * pause & unpause minting functions that can be called by only platform owner 
 * and change NFT price that can be called by NFT owner only.
 */
contract MintCars is Ownable, ERC721URIStorage, Pausable{
    
   using SafeMath for uint256;

   uint256 public tokenCounter;
   mapping (uint=> uint) price; 
   event priceChanged(uint newPrice, uint Id);

    /**
     * @dev Initializes the contract by calling erc721 constructor 
     * and passing a `name` and a `symbol` to it.
     */
   
    constructor(string memory name_, string memory symbol_) ERC721(name_,symbol_) {
       tokenCounter = 0;
    }


    modifier onlyNftOwner(uint256 _tokenID, address _caller){
       require((ownerOf(_tokenID)==_caller),"Error : Only Owner of NFT can change NFT price");
       _;
    }
    
    /**
     *  MintCarsNFT function allow users to create car NFTs
    */ 
    
    function MintCarsNFT(string memory _tokenUri , uint _tokenPrice) public whenNotPaused returns(uint256){
            
        uint256 newItemID = tokenCounter;
        
        _safeMint(msg.sender, newItemID);
        _setTokenURI(newItemID,_tokenUri);
        price[newItemID] = _tokenPrice;
        tokenCounter= tokenCounter.add(1);
    
        return newItemID;
    }

    function pauseMinting () public onlyOwner{
        _pause();
    }

    function unpauseMinting () public  onlyOwner{
        _unpause();
    }

    function viewPrice(uint256 _tokenID) view public returns(uint256){
      return price[_tokenID] ;
    }


    /**
     * @dev Throws if called by any account other than NFT Owner.
     */

    function changePrice(uint256 _tokenID, uint256 _newPrice) public onlyNftOwner(_tokenID,msg.sender){
        price[_tokenID] = _newPrice;
        emit priceChanged(_newPrice, _tokenID);
    }

}