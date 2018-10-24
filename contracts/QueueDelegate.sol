import './IDelegate.sol';

contract QueueDelegate is IDelegate {
    struct Delegate {
        address addr;
        uint256 amount;
    }

    //Delegate[] delegates;

    function join (uint256 stake_amount) public {
        Delegate memory d = Delegate({
            addr: msg.sender,
            amount: stake_amount
        });
        //delegates.push(d);
        add(d);
    }

    function withdraw () public {
        withdraw_some( delegates[msg.sender].amount );
    }

    function withdraw_some (uint256 stake_amount) public {
        if ( delegates[ bytes32(msg.sender) ].info.amount <= stake_amount )
            remove( msg.sender );
        else
            delegates[ bytes32(msg.sender) ].info.amount -= stake_amount; // Make this safe subtract
    }


    //
    // Linked list impl
    //
    struct Node {
        bytes32 next;
        bytes32 prev;
        Delegate info;
    }

    uint256 length = 0;
    bytes32 public head;
    mapping (address => Node) public delegates;

    function add(Delegate d) private {
        Node memory node = Node(head, d);
        //bytes32 id = sha3(d.addr, now, d.amount);
        bytes32 id;
        address a = d.addr;
        assembly {
            id := mload(a)
        }
        //bytes32 id = bytes32(d.addr);
        delegates[id] = node;
        head       = id;
        length     = length+1;
    }

    function remove(address addr) private {
        Node storage n = delegates[ bytes32(addr) ];
        Node next_id = n.next;
        Node prev_id = n.prev;

        delegates[prev_id].next = next_id;
        delete n;
    }
}
