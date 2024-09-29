// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {CommonBase} from "forge-std/Base.sol";
import {Phylax} from "./Phylax.sol";

/// @title PhylaxBase
/// @dev Base contract for all Phylax alert contracts.
abstract contract PhylaxBase is CommonBase {
    /// @dev Instance of Phylax contract
    Phylax internal ph = Phylax(address(VM_ADDRESS));
    /// @dev Array of active chains
    uint256[] internal activeChains;

    /// @dev Event to export key value pair
    event PhylaxExport(string key, string value);

    /// @dev Struct for labels
    struct Label {
        string key;
        string value;
    }

    /// @notice Modifier to select a chain
    /// @dev Exports "fork_activated" and selects the fork at the given index
    /// @param index The index of the chain to select
    modifier chain(uint256 index) {
        ph.selectFork(activeChains[index]);
        _;
    }

    /// @notice Enables a new chain
    /// @param aliasOrUrl The alias or URL of the chain to enable. The alias is used
    /// when the RPC is defined in `foundry.toml`, as in Forge fork tests.
    /// @return The index of the newly enabled forked chain
    function enableChain(string memory aliasOrUrl) internal returns (uint256) {
        activeChains.push(ph.createFork(aliasOrUrl));
        return activeChains.length - 1;
    }

    /// @notice Enables a new chain

    /// @param aliasOrUrl The alias or URL of the chain to enable. The alias is used
    /// when the RPC is defined in `foundry.toml`, as in Forge fork tests.
    /// @param blockNumber The block number at which the chain should be forked
    /// @return The index of the newly enabled forked chain
    function enableChain(string memory aliasOrUrl, uint256 blockNumber) internal returns (uint256) {
        activeChains.push(ph.createFork(aliasOrUrl, blockNumber));
        return activeChains.length - 1;
    }

    /// @notice Export a name/value pair to Phylax
    /// @dev It's exposed via the API and if it's numerical, via the prometheus endpoint as well.
    /// @param key The key of the value to export
    /// @param value The value to export
    function export(string memory key, string memory value) internal {
        emit PhylaxExport(key, value);
    }

    /// @dev Event for creating a monitor
    event PhylaxCreateMonitor(
        string name,
        string description,
        string unitLabel,
        uint8 visualization,
        uint8 dataPointType,
        Label[] labels
    );

    /// @notice Setup a unique monitor for your Alert in Phylax
    /// @dev This is only scanned during the `setUp` function of 
    /// the alert, it's output will not be read when tests are running.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart
    /// @param visualization The visualization of the chart
    /// @param dataPointType The data point type of the chart
    /// @param labels The labels of the chart
    function createChartMonitor(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        uint8 visualization,
        uint8 dataPointType,
        Label[] memory labels
    ) external {
        emit PhylaxCreateMonitor(
            chartName,
            description,
            unitLabel,
            visualization,
            dataPointType,
            labels
        );
    }
}
