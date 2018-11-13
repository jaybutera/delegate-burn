pragma solidity ^0.4.24;

import './IDelegate.sol';
//import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol';
import './PoB/BurnableERC20.sol';
import './PoB/BurnableStakeBank.sol';

contract QueueDelegate {// is IDelegate {
    event Debug(uint256 x);
    mapping (address => Staker) public stakers;
    //BurnableERC20 token;
    BurnableStakeBank bsb;

    constructor (BurnableStakeBank _bsb) {
        //token = _token;
        bsb   = _bsb;
    }

    // Returns address of staker that was burned for
    function burnAllForNext (bytes __data) public returns (address) {
        address headCpy = head; // Copy head because it may change after burn
        emit Debug(stakers[headCpy].amount);
        burn(stakers[headCpy].amount, __data);
        return headCpy;
    }

    function burn (uint256 amount, bytes __data) public {
        bsb.burnFor(head, amount, __data); // TODO: specify token name in data

        // If all is burned from staker, remove from queue
        if ( amount >= stakers[head].amount ) {
            address tmp = stakers[head].next; // Temporary storage for new head ptr
            remove(head);            // Remove current head node
            head = tmp;              // Replace head ptr
        }
    }

    function join (uint256 stake_amount, bytes token_id) public {
        // Transfer staker funds to delegate account
        // token.transferFrom(msg.sender, this, stake_amount);
        bsb.stakeFor(msg.sender, stake_amount, token_id);

        // Add staker to bstake urn list
        add(msg.sender, stake_amount);
    }

    function withdraw (bytes token_id) public {
        //require( stakers[msg.sender].exists == true );

        withdrawSomeFor(msg.sender, stakers[msg.sender].amount, token_id );
    }

    function withdrawSomeFor (address user, uint256 stake_amount, bytes token_id) public {
        //require( stakers[msg.sender].exists == true );
        require( stakers[msg.sender].amount >= stake_amount );

        // Return staker's money
        bsb.unstakeFor(user, stake_amount, token_id);

        // TODO: Should not track stake amount in QD contract since it's already tracked in BSB

        // Subtract amount or remove staker from burn list altogether
        if ( stakers[ msg.sender ].amount <= stake_amount )
            remove( msg.sender );
        else
            stakers[ msg.sender ].amount -= stake_amount; // Make this a safe subtract

        // Decrement
        length -= 1;
    }

    function get (address a) view public returns (uint256) {
        return stakers[a].amount;
    }


    //
    // Linked list impl
    //
    struct Staker {
        address next;
        address prev;
        uint256 amount;
        bool exists;
    }

    uint256 public length = 0;
    address head;

    function add(address _addr, uint256 _amount) private {
        stakers[_addr] = Staker({
            next: address(0),
            prev: head,
            amount: _amount,
            exists: true
        });

        head = _addr;
        length += 1;
    }

    function remove(address _addr) private {
        Staker storage d = stakers[_addr];
        address next_id = d.next;
        address prev_id = d.prev;

        stakers[prev_id].next = next_id;
        delete stakers[_addr];
    }
}

