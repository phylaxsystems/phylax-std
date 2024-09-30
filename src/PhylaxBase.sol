// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {CommonBase} from "forge-std/Base.sol";
import {Phylax} from "./Phylax.sol";

/// @title PhylaxBase
/// @dev Base contract for all Phylax alert contracts.
abstract contract PhylaxBase is CommonBase {
    /// @dev Instance of Phylax contract
    Phylax internal ph = Phylax(address(vm));
    /// @dev Array of active chains
    uint256[] internal activeChains;

    /// @dev Event to export key value pair
    event PhylaxExport(string key, string value);

    /// @notice Modifier to select a chain
    /// @dev Exports "fork_activated" and selects the fork at the given index
    /// @param index The index of the chain to select
    modifier chain(uint256 index) {
        vm.selectFork(activeChains[index]);
        _;
    }

    /// @notice Enables a new chain
    /// @param aliasOrUrl The alias or URL of the chain to enable. The alias is used
    /// when the RPC is defined in `foundry.toml`, as in Forge fork tests.
    /// @return The index of the newly enabled forked chain
    function enableChain(string memory aliasOrUrl) internal returns (uint256) {
        activeChains.push(vm.createFork(aliasOrUrl));
        return activeChains.length - 1;
    }

    /// @notice Enables a new chain

    /// @param aliasOrUrl The alias or URL of the chain to enable. The alias is used
    /// when the RPC is defined in `foundry.toml`, as in Forge fork tests.
    /// @param blockNumber The block number at which the chain should be forked
    /// @return The index of the newly enabled forked chain
    function enableChain(string memory aliasOrUrl, uint256 blockNumber) internal returns (uint256) {
        activeChains.push(vm.createFork(aliasOrUrl, blockNumber));
        return activeChains.length - 1;
    }

    /// @notice Export a name/value pair to Phylax
    /// @dev It's exposed via the API and if it's numerical, via the prometheus endpoint as well.
    /// @param key The key of the value to export
    /// @param value The value to export
    function export(string memory key, string memory value) internal {
        emit PhylaxExport(key, value);
    }

    /// Add additional events here ...
}
