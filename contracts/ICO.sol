//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ICO is Ownable{

    address public adminWallet;
    // address public icoContract;
    mapping (address => uint256) userdata;

    event tokenTransfer(address _userWallet, uint256 amount);

    constructor(address _adminWallet)  {
        adminWallet = _adminWallet;             
    }

    function transferToken(address _tokenContract, uint256 amount, address _userWallet) public {
        require(msg.sender == adminWallet, "You aren't the adminWallet");
        userdata[_userWallet] = userdata[_userWallet] + amount;
        uint256 depositAmount = userdata[_userWallet];
        IERC20(_tokenContract).transferFrom(adminWallet, _userWallet, amount);
        emit tokenTransfer(_userWallet, depositAmount);        
    }

    function updateAdmin(address _newAddress) external onlyOwner{
        adminWallet = _newAddress;
    }

}
