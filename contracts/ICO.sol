//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// import "hardhat/console.sol";
import "./IBTUSD.sol";

contract ICO {

    address public owner;
    // address public icoContract;
    mapping (address => uint256) userdata;

    event tokenTransfer(address _userWallet, uint256 amount);

    constructor(address _owner)  {
        owner = _owner;             
    }

    function transferToken(address _icoContract, uint256 amount, address _userWallet) public {
        require(msg.sender == owner, "You aren't the owner");
        userdata[_userWallet] = userdata[_userWallet] + amount;
        uint256 depositAmount = userdata[_userWallet];
        IBTUSD(_icoContract).transferFrom(_icoContract, _userWallet, amount);
        emit tokenTransfer(_userWallet, depositAmount);        
    }

}
