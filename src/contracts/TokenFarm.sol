// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./DaiToken.sol";
import "./DappToken.sol";

contract TokenFarm {
    string public name = "Dapp Token Farm";
    DaiToken public daiToken;
    DappToken public dappToken;
    address owner;

    address[] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public isStaking;
    mapping(address => bool) public hasStaked;

    constructor(DaiToken _daiToken, DappToken _dappToken) {
        daiToken = _daiToken;
        dappToken = _dappToken;

        owner = msg.sender;
    }

    function stakeDaiTokens(uint256 _value) public {
        require(_value > 0, "staking amount must be grater than 0");

        daiToken.transferFrom(msg.sender, address(this), _value);

        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _value;

        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        hasStaked[msg.sender] = true;
        isStaking[msg.sender] = true;
    }

    function unstakeDaiTokens() public {
        uint256 balance = stakingBalance[msg.sender];

        require(balance > 0, "current balance must be greater than 0");

        daiToken.transfer(msg.sender, balance);

        stakingBalance[msg.sender] = 0;
        isStaking[msg.sender] = false;
    }

    function issueDappTokens() public {
        require(msg.sender == owner, "only owner can trigger issue tokens");

        for (uint256 i = 0; i < stakers.length; i++) {
            address staker = stakers[i];
            uint256 balance = stakingBalance[staker];
            if (balance > 0) {
                dappToken.transfer(staker, balance);
            }
        }
    }
}
