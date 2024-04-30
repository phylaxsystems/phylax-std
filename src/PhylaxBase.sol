// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {CommonBase} from "forge-std/Base.sol";
import {Phylax} from "./Phylax.sol";

/// @title PhylaxBase
/// @dev Base contract for all Phylax alert contracts.
abstract contract PhylaxBase is CommonBase {
    /// @dev Instance of Phylax contract
    Phylax internal ph;
    /// @dev Array of active chains
    uint256[] internal $activeChains;

    /// @notice Sets up the Phylax contract
    /// @dev Instantiates a new Phylax contract and assigns it to the ph variable
    function setupPhylax() internal {
        ph = new Phylax();
        // This is required so that the contract is persistent across forks
        vm.makePersistent(address(ph));
    }

    /// @notice Enables a new chain
    /// @param aliasOrUrl The alias or URL of the chain to enable. The alias is used
    /// when the RPC is defined in `foundry.toml`, as in Forge fork tests.
    /// @return The index of the newly enabled forked chain
    function enableChain(string memory aliasOrUrl) internal ensurePhylaxSetup returns (uint256) {
        $activeChains.push(vm.createFork(aliasOrUrl));
        return $activeChains.length - 1;
    }

    /// @notice Enables a new chain

    /// @param aliasOrUrl The alias or URL of the chain to enable. The alias is used
    /// when the RPC is defined in `foundry.toml`, as in Forge fork tests.
    /// @param blockNumber The block number at which the chain should be forked
    /// @return The index of the newly enabled forked chain
    function enableChain(string memory aliasOrUrl, uint256 blockNumber) internal ensurePhylaxSetup returns (uint256) {
        $activeChains.push(vm.createFork(aliasOrUrl, blockNumber));
        return $activeChains.length - 1;
    }

    /// @notice Modifier to select a chain
    /// @dev Exports "fork_activated" and selects the fork at the given index
    /// @param index The index of the chain to select
    modifier chain(uint256 index) {
        vm.selectFork($activeChains[index]);
        _;
    }

    /// @notice Modifier to ensure Phylax is setup
    /// @dev Instantiates Phylax if not already setup
    modifier ensurePhylaxSetup() {
        if (address(ph) == address(0)) {
            setupPhylax();
        }
        _;
    }
}
