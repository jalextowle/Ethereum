pragma solidity ^0.4.24;

// [root][left child][right child][left left child][left right child]
contract BST {
    
    /**
     * FIXME -- It would make more sense to make a BST with these elements in place, so this will most likely not be used
     * @dev This functions makes a binary search tree in memory with minimal memory requirements. 
     * @param entries The values to initialize the BST with
     * @return ptr A pointer to the BST in memory
     */
    function make_BST(uint[] memory entries) internal pure returns (uint ptr) {
        assembly {
           ptr := mload(0x40)
           mstore(ptr, mload(add(0x20, entries)))
        }
        for (uint i = 1; i < entries.length; i++)
            add_child(0, ptr, entries[i]);    
    }
    
    /**
     * @dev Adds a number to be a child of a node in a BST, and if the node 
     * already has children, routes the call to the appropriate node.
     * @param node The node number -- will be defined in the README.md FIXME
     * @param offset The offset to the BST in memory 
     * @param child The value to be added to the BST 
     */
    function add_child(uint node, uint offset, uint child) internal pure {
        if (child < node) {
            if (has_child(node, offset, true)) {
                add_child(2 * node + 1, offset, child);
            } else {
                add_left(node, offset, child);
            }
        } else if (child > node) {
            if (has_child(node, offset, false)) {
                add_child(2 * node + 2, offset, child);
            } else {
                add_right(node, offset, child);
            }
        } else {
            return;
        }
    }
    
    
    /**
     * @dev Adds a number to be the left child of a node in a BST
     * @param node The node number -- will be defined in the README.md FIXME
     * @param offset The offset to the BST in memory 
     * @param child The value to be added to the BST 
     */
    function add_left(uint node, uint offset, uint child) internal pure {
        // 2 * node + 1
        // mstore(32 * 2 * node + 32 * 1, child)
        assembly {
            let base_position := add(mul(node, 0x40), 0x20)
            mstore(add(base_position, offset), child) 
        }
    }
    
    /**
     * @dev Adds a number to be the right child of a node in a BST
     * @param node The node number -- will be defined in the README.md FIXME
     * @param offset The offset to the BST in memory 
     * @param child The value to be added to the BST 
     */
    function add_right(uint node, uint offset, uint child) internal pure {
        // 2 * node + 2
        // mstore(32 * (2 * (node + 1)), child)
        assembly { 
            let base_position := mul(add(node, 0x1), 0x40)
            mstore(add(base_position, offset), child) 
        }
    }
    
    /// Helpers ///
    
    /**
     * @dev Determines whether a specified node has a child on a specified side
     * @param node The node number -- will be defined in the README.md FIXME
     * @param offset The offset to the BST in memory 
     * @return The boolean representing whether or not the node has a child 
     */
    function has_child(uint node, uint offset, bool left) internal pure returns (bool) {
        if (left) {
            return getLeft(node, offset) == 0 ? false : true;
        } else {
            return getRight(node, offset) == 0 ? false : true;
        }
    }
    
    /**
     * @dev Gets the left child of a specified node number
     * @param node The node number -- will be defined in the README.md FIXME
     * @param offset The offset to the BST in memory 
     */
    function getLeft(uint node, uint offset) internal pure returns (uint left) {
        assembly { 
          let base_position := add(mul(node, 0x40), 0x20) 
          left := mload(add(base_position, offset)) 
        }   
    }
    
    /**
     * @dev Gets the right child of a specified node number
     * @param node The node number -- will be defined in the README.md FIXME
     * @param offset The offset to the BST in memory 
     */
    function getRight(uint node, uint offset) internal pure returns (uint right) {
        assembly { 
          let base_position := mul(add(node, 0x1), 0x40)
          right :=  mload(add(base_position, offset)) 
        }   
    }
    
}
