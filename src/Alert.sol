// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {Test} from "forge-std/Test.sol";
import {Phylax} from "./Phylax.sol";

/// @title Alert
/// @dev Base contract for all Phylax alert contracts.
abstract contract Alert is Test {
    /// @dev Phylax instance
    Phylax internal constant ph = Phylax(VM_ADDRESS);

    /// @dev Array of active chains
    uint256[] $activeChains;

    /// @notice Enables a new chain
    /// @param aliasOrUrl The alias or URL of the chain to enable
    /// @return The index of the newly enabled chain
    function enableChain(
        string calldata aliasOrUrl
    ) internal returns (uint256) {
        $activeChains.push(vm.createFork(aliasOrUrl));
        return $activeChains.length - 1;
    }

    /// @notice Modifier to select a chain
    /// @dev Exports "fork_activated" and selects the fork at the given index
    /// @param index The index of the chain to select
    modifier chain(uint256 index) {
        ph.export("fork_activated", "");
        vm.selectFork($activeChains[index]);
        _;
    }
}
