// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./DaiToken.sol";
import "./DappToken.sol";

contract TokenFarm {
    string public name = "Dapp Token Farm";
    DaiToken public daiToken;
    DappToken public dappToken;

    address[] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public isStaking;
    mapping(address => bool) public hasStaked;

    constructor(DaiToken _daiToken, DappToken _dappToken) {
        daiToken = _daiToken;
        dappToken = _dappToken;
    }

    function stakeDaiTokens(uint256 _value) public {
        daiToken.transferFrom(msg.sender, address(this), _value);

        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _value;

        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        hasStaked[msg.sender] = true;
        isStaking[msg.sender] = true;
    }
}
