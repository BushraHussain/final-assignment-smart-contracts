// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import './MintCars.sol';
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


/**
 * @dev Contract module provides mechanism for buying NFT, 
 * change tax address, tax percent and inviter reward percent 
 * on each trade that can be called by current owner only
 */


contract TradeCars is MintCars{

    using SafeMath for uint256;

    // Platform fee 
    uint256 public platformTaxFee; 

    // Account that receive platform fee
    address payable taxAddress; 

    // Soap NFT holder reward percent who invites an artist
    //uint256 soapHolderRewardPercent;   

    
    mapping (uint=>bool) public sold;
    event purchased(address owner,uint price, uint tokenId, string uri);

    /**
     * @dev Initializes the contract by calling MintCars contract constructor 
     * and passing a `name` and a `symbol` to it.
     * By default, tax address account will be the one that deploys the contract.
     * By default, platform tax is set to 10%
     * By default, soap NFT holder reward is set to 3% 
     */

    constructor(string memory name_, string memory symbol_) MintCars(name_,symbol_){
        taxAddress = payable(0xBef33C394213BD8A240C16c86a03C76d7E7bE1fa);
        platformTaxFee = 5;
       // soapHolderRewardPercent=5;
    }

   

    function BuyCarsNFT(uint256 _tokenId) external payable{
        validateTokenID(_tokenId);
        trade(_tokenId);
        emit purchased(msg.sender, price[_tokenId], _tokenId, tokenURI(_tokenId)); 
    }


    function validateTokenID(uint _tokenId) internal{
        require(_exists(_tokenId), "Error: Invalid Token ID");
        require(!sold[_tokenId], "Sorry: Token has been sold");
        require((msg.value >= price[_tokenId]),"Invalid Amount");
    }

    function trade(uint _tokenID) internal{

        uint256 returnAmount = msg.value.sub(price[_tokenID]); 
        payable(msg.sender).transfer(returnAmount); // return extra amount back to buyer 
        
        uint256 receivedAmount = msg.value.sub(returnAmount); 

        uint256 calculateTax = receivedAmount.mul(platformTaxFee).div(100); 
        taxAddress.transfer(calculateTax); // send to platform owner
        uint256 remaining = receivedAmount.sub(calculateTax);

        payable(ownerOf(_tokenID)).transfer(remaining); // send to artist (NFT seller)
        _transfer(ownerOf(_tokenID),msg.sender,_tokenID); // transfer ownership of NFT to buyer(caller)

         sold[_tokenID] = true;

        
    }

   
    /**
     * @dev Change tax Address (account that receive platform fee) to a new account.
     * Can only be called by the current owner.
     */
    function changeTaxAddress(address payable _newTaxAddress) external onlyOwner {
        taxAddress = _newTaxAddress;
    }


    /**
     * @dev Returns current tax address that receive platform fee.
     * Can only be called by the current owner.
     */
    function viewCurrentTaxAddress() view external onlyOwner returns (address) {
        return taxAddress;
    }

    /**
     * @dev change platform tax (fee) to a new percent.
     * Can only be called by the current owner.
     */
    function changeTaxPercent(uint _newTaxPercent) external onlyOwner {
        platformTaxFee = _newTaxPercent;
    }


    /**
     * @dev fallbacks for value and data transactions.
     */
    fallback() external payable{
    }
     
    receive() external payable{
    }


    /**
     * @dev transfer full contract balance to provided account 
     * Can only be called by the current owner.
     */
    function transferToOwner(address payable _addressToWithdraw) external onlyOwner returns(uint256){
        _addressToWithdraw.transfer(address(this).balance);
        return _addressToWithdraw.balance;
    }


    /**
     * @dev To close the contract and transfer full contract balance to provided account.
     * Contract can be closed by the current owner only.
     */
    function CloseContract(address payable _addressToWithdraw) external onlyOwner{ 
        selfdestruct(_addressToWithdraw);
    }


}