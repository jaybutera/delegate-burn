pragma solidity ^0.4.24;

import './IDelegate.sol';
//import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol';
import './PoB/BurnableERC20.sol';
import './PoB/BurnableStakeBank.sol';

contract QueueDelegate is IDelegate {
    mapping (address => Delegate) public delegates;
    //BurnableERC20 token;
    BurnableStakeBank bsb;

    constructor (BurnableStakeBank _bsb) {
        //token = _token;
        bsb   = _bsb;
    }

    // Returns address of staker that was burned for
    function burnAllForNext (bytes __data) public returns (address) {
        address headCpy = head; // Copy head because it will change after burn
        bsb.burn( delegates[headCpy].amount, __data );
        return headCpy;
    }

    function burn (uint256 amount, bytes __data) public {
        bsb.burnFor(head, amount, __data); // TODO: specify token name in data

        // If all is burned from staker, remove from queue
        if ( amount >= delegates[head].amount ) {
            address tmp = head.next; // Temporary storage for new head ptr
            remove(head);            // Remove current head node
            head = tmp;              // Replace head ptr
        }
    }

    function join (uint256 stake_amount, bytes token_id) public {
        // Transfer staker funds to delegate account
        // token.transferFrom(msg.sender, this, stake_amount);
        bsb.stake(msg.sender, stake_amount, token_id);

        // Add staker to burn list
        add(msg.sender, stake_amount);
    }

    function withdraw () public {
        //require( delegates[msg.sender].exists == true );

        withdraw_some( delegates[msg.sender].amount );
    }

    function withdraw_some (uint256 stake_amount) public {
        //require( delegates[msg.sender].exists == true );
        require( delegates[msg.sender].amount >= stake_amount );

        // Return staker's money
        token.transfer(msg.sender, stake_amount);

        // Subtract amount or remove staker from burn list altogether
        if ( delegates[ msg.sender ].amount <= stake_amount )
            remove( msg.sender );
        else
            delegates[ msg.sender ].amount -= stake_amount; // Make this a safe subtract

        // Decrement
        length -= 1;
    }

    function get (address a) view public returns (uint256) {
        return delegates[a].amount;
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

    uint256 public length = 0;
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

