pragma solidity ^0.4.24;

import "./IRewardByBlock.sol";
import "./QueueDelegate.sol";

contract Reward is IRewardByBlock {
    QueueDelegate qd;

    constructor(QueueDelegate _qd) public {
        qd = _qd;
    }

    function reward(address[] benefactors, uint16[] kind)
        external
        returns (address[], uint256[])
    {
        // Burn their tokens
        address staker = qd.burnAllForNext();
        address[] memory s = new address[](1);
        s[0] = staker;

        uint256 reward = 1; // Ugly ass constant
        uint256[] memory r = new uint256[](1);
        r[0] = reward;

        // Mint c4coin
        return (s, r);
    }
}
