//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ICO is Ownable{   

    address public adminWallet;
    // userdata[userWallet][tokenContract]
    mapping (address => mapping(address=>uint256)) public userdata;

    event tokenTransfer(address _userWallet, uint256 amount);
    uint256 public presaleMaxAmount = 10000000*10**18; // 10 milion
    uint256 public publicMaxAmount = 150000000*10**18; // 150 milion
    mapping (address => uint256) public presaleAmount;
    mapping (address => uint256) public publicSaleAmount;
    // saleStatus[tokenContract] 
    mapping (address => uint) public saleStatus; // sale status: 0- presale, 1- public sale, 2- other sale

    constructor()  {
        adminWallet = msg.sender;             
    }

    //make the ICO website for 10 million presale and 150 million public sale and we will keep the rest in reserve to sell latter
    function transferToken(address _tokenContract, uint256 amount, address _userWallet) public {
        require(msg.sender == adminWallet, "You aren't the adminWallet");
        if (saleStatus[_tokenContract] == 0){
            presaleAmount[_tokenContract] = presaleAmount[_tokenContract]+amount;
            require(presaleAmount[_tokenContract] < presaleMaxAmount, "Exceeds PreSale Max Amount");
        }        
        else if(saleStatus[_tokenContract] == 1){
            publicSaleAmount[_tokenContract]  = publicSaleAmount[_tokenContract] + amount;
            require(publicSaleAmount[_tokenContract] < publicMaxAmount, "Exceeds Public Sale Max Amount");
        }
        userdata[_userWallet][_tokenContract] = userdata[_userWallet][_tokenContract] + amount;
        uint256 depositAmount = userdata[_userWallet][_tokenContract];
        IERC20(_tokenContract).transferFrom(adminWallet, _userWallet, amount);
        emit tokenTransfer(_userWallet, depositAmount);        
    }

    function updateAdmin(address _newAddress) external onlyOwner{
        adminWallet = _newAddress;
    }

    // sale status: 0- presale, 1- public sale, 2- other sale
    function updateSaleStatus(address _tokenContract, uint _value) external onlyOwner{        
        saleStatus[_tokenContract] = _value;
    }

}
