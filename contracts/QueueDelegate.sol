pragma solidity ^0.4.24;

import './IDelegate.sol';

contract QueueDelegate is IDelegate {
    mapping (address => Delegate) delegates;

    function join (uint256 stake_amount) public {
        add(msg.sender, stake_amount);
    }

    function withdraw () public {
        //require( delegates[msg.sender].exists == true );

        withdraw_some( delegates[msg.sender].amount );
    }

    function withdraw_some (uint256 stake_amount) public {
        //require( delegates[msg.sender].exists == true );

        if ( delegates[ msg.sender ].amount <= stake_amount )
            remove( msg.sender );
        else
            delegates[ msg.sender ].amount -= stake_amount; // Make this a safe subtract
    }


    //
    // Linked list impl
    //
    struct Delegate {
        address next;
        address prev;
        uint256 amount;
        bool exists;
    }

    uint256 length = 0;
    address head;

    function add(address _addr, uint256 _amount) private {
        delegates[_addr] = Delegate({
            next: address(0),
            prev: head,
            amount: _amount,
            exists: true
        });

        head = _addr;
        length += 1;
    }

    function remove(address _addr) private {
        Delegate storage d = delegates[_addr];
        address next_id = d.next;
        address prev_id = d.prev;

        delegates[prev_id].next = next_id;
        delete delegates[_addr];
    }
}
