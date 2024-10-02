// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {CommonBase, Vm} from "forge-std/Base.sol";

/// @title Vm-like interface for Phylax
/// @dev It includes cheatcodes that are available in the phylax fork of foundry, but have not been upstreamed
interface Phylax is Vm {
    /// @dev updates the currently activated fork to the specified block number
	function rollForkAt(uint256 blockNumber) external;

    /// @dev rolls back the from the current block number to a specified number of blocks in the past
    /// which enables improved caching and better test load times
	function rollForkBack(uint256 blocksInThePast) external;

	/// @dev updates the specific fork with forkId to the block number
	function rollForkAt(uint256 forkId, uint256 blockNumber) external;
    
    /// @dev rolls back to a specific fork id by a specified number of blocks from 
    // the current block number, which enables improved caching and faster execution times
	function rollForkBack(uint256 forkId, uint256 blocksInThePast) external;
    

    /// Creates a new fork with the given chainId and the _latest_ block, if there is a watcher
    /// connected to the alert running the cheatcode.
    function createFork(uint256 chainId) external returns (uint256 forkId);

    /// Creates a new fork with the given chainId and the specified block number, if there is a watcher
    /// connected to the alert running the cheatcode.
    function createFork(uint256 chainId, uint256 blockNumber) external returns (uint256 forkId);

    /// Creates and also selects a new fork with the given chainId and the latest block and returns the identifier of the fork.
    /// If there is no watcher connected to the alert running the cheatcode with the specified chainid, it will fail.
    function createSelectFork(uint256 chainId) external returns (uint256 forkId);
    
    /// Creates and also selects a new fork with the given chainId and block and returns the identifier of the fork.
    /// If there is no watcher connected to the alert running the cheatcode with the specified chainid, it will fail.
    function createSelectFork(uint256 chainId, uint256 blockNumber) external returns (uint256 forkId);

    /// Add additional cheatcodes here...

}
