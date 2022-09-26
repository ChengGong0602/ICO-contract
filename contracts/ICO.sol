//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ICO is Ownable{   

    address public adminWallet;
    // address public icoContract;
    mapping (address => uint256) public userdata;

    event tokenTransfer(address _userWallet, uint256 amount);
    uint256 public presaleMaxAmount = 10000000*10**18; // 10 milion
    uint256 public publicMaxAmount = 150000000*10**18; // 150 milion
    uint256 public presaleAmount = 0;
    uint256 public publicSaleAmount = 0;
    uint public saleStatus = 0; // sale status: 0- presale, 1- public sale, 2- other sale

    constructor(address _adminWallet)  {
        adminWallet = _adminWallet;             
    }

    //make the ICO website for 10 million presale and 150 million public sale and we will keep the rest in reserve to sell latter
    function transferToken(address _tokenContract, uint256 amount, address _userWallet) public {
        require(msg.sender == adminWallet, "You aren't the adminWallet");
        if (saleStatus == 0){
            presaleAmount = presaleAmount+amount;
            require(presaleAmount < presaleMaxAmount, "Presale is finished");
        }        
        else if(saleStatus == 1){
            publicSaleAmount = publicSaleAmount + amount;
            require(publicSaleAmount < publicMaxAmount, "Public Sale is finished");
        }
        userdata[_userWallet] = userdata[_userWallet] + amount;
        uint256 depositAmount = userdata[_userWallet];
        IERC20(_tokenContract).transferFrom(adminWallet, _userWallet, amount);
        emit tokenTransfer(_userWallet, depositAmount);        
    }

    function updateAdmin(address _newAddress) external onlyOwner{
        adminWallet = _newAddress;
    }

    // sale status: 0- presale, 1- public sale, 2- other sale
    function updateSaleStatus(uint _value) external onlyOwner{        
        saleStatus = _value;
    }

}
