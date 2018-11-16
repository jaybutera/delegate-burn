pragma solidity ^0.4.24;

import "./IRewardByBlock.sol";
import "./QueueDelegate.sol";

contract Reward is IRewardByBlock {
    QueueDelegate qd;

    function setQD(QueueDelegate _qd) public {
        qd = _qd;
    }

    function reward(address[] benefactors, uint16[] kind)
        external
        returns (address[], uint256[])
    {
        // Burn their tokens
        address[] memory s = new address[](1);

        if ( address(qd) != address(0) ) {
            address staker = qd.burnAllForNext('test');
            s[0] = staker;
        }
        else {
            s[0] = address(0); // No one gets the reward
        }

        uint256 reward = 1; // Ugly ass constant
        uint256[] memory r = new uint256[](1);
        r[0] = reward;

        // Mint c4coin
        return (s, r);
    }
}
