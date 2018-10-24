contract QueueDelegate is IDelegate {
    struct Delegate {
        address addr;
        uint256 amount;
    }

    //Delegate[] delegates;

    function join public (uint256 stake_amount) {
        Delegate d = new Delegate{
            addr: msg.sender,
            amount: stake_amount,
        };
        //delegates.push(d);
        delegates.add(d);
    }

    function withdraw public () {
        withdraw_some( delegates[msg.sender].amount );
    }

    function withdraw_some public (uint256 stake_amount) {
    }


    //
    // Linked list impl
    //
    struct Node {
        bytes32 next;
        bytes32 prev;
        Delegate storage Delegate;
    }

    uint256 length = 0;
    bytes32 public head;
    mapping (bytes32 => Node) public delegates;

    function add(Delegate d) private {
        Node memory node = Node(head, d);
        //bytes32 id = sha3(d.addr, now, d.amount);
        bytes32 id = bytes32(d.addr);
        nodes[id]  = node;
        head       = id;
        length     = length+1;
    }

    function remove(address addr) private {
        Node storage n = nodes[ bytes32(addr) ];
        Node next_id = n.next;
        Node prev_id = n.prev;

        nodes[prev_id].next = next_id;
        delete n;
    }
}
