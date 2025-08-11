//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/*
 * @title Decentralized Stable Coin
 * @author Ayush Popat
 */

error DecentralizedStableCoin__MustBeMoreThanZero();
error DecentralizedStableCoin__MustBeMoreThanBalance();
error DecentralizedStableCoin__ZeroAddressDetected(address zeroAddress);


contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    constructor() ERC20("DecentralizedStableCoin", "DSC") Ownable(msg.sender) {}
    function burn(uint256 _amount) public override(ERC20Burnable) {
        uint256 balance = balanceOf(msg.sender);
        if(_amount<=0){
            revert DecentralizedStableCoin__MustBeMoreThanZero();
        }
        if(_amount > balance){
            revert DecentralizedStableCoin__MustBeMoreThanBalance();
        }

        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
        if(_to == address(0)) {
            revert DecentralizedStableCoin__ZeroAddressDetected(_to);
        }
        if(_amount <= 0){
            revert DecentralizedStableCoin__MustBeMoreThanZero();
        }
        _mint(_to, _amount);
        
        return true;
    }
}
