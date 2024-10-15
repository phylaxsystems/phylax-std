// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

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

    /// @notice The visualization enum for describing the type of chart you will create.
    /// @dev This enum is used to create charts in the Phylax GUI and in the telemetry exports.
    enum Visualization {
        Bar,
        Line,
        Heatmap,
        Gauge,
        Table,
        LastValue
    }

    /// @notice The data point type enum for describing the type of data point you will create.
    enum DataPointType {
        Uint,
        Int,
        String
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
    function enableChain(
        string memory aliasOrUrl,
        uint256 blockNumber
    ) internal returns (uint256) {
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
        Visualization visualization,
        DataPointType dataPointType,
        Label[] labels
    );

    /// @notice Setup a unique monitor for your Alert in Phylax
    /// @dev This is only scanned during the `setUp` function of
    /// the alert, it's output will not be read when tests are running.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart
    function createChartMonitor(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        Visualization visualization,
        DataPointType dataPointType,
        Label[] memory labels
    ) public {
        emit PhylaxCreateMonitor(
            chartName,
            description,
            unitLabel,
            visualization,
            dataPointType,
            labels
        );
    }

    /// @dev Event for exporting monitor string data points
    event PhylaxWriteStringMonitor(string name, string value, Label[] labels);

    /// @dev Event for exporting monitor uint data points
    event PhylaxWriteUintMonitor(string name, uint64 value, Label[] labels);

    /// @dev Event for exporting monitor int data points
    event PhylaxWriteIntMonitor(string name, int64 value, Label[] labels);

    /// @notice Send data to a Phylax monitor which accepts string data, if it was instantiated.
    function writeDataPointString(
        string memory chartName,
        string memory value,
        Label[] memory labels
    ) public {
        emit PhylaxWriteStringMonitor(chartName, value, labels);
    }

    /// @notice Send data to a Phylax monitor which accepts uint data, if it was instantiated.
    function writeDataPointUint(
        string memory chartName,
        uint64 value,
        Label[] memory labels
    ) public {
        emit PhylaxWriteUintMonitor(chartName, value, labels);
    }

    /// @notice Send data to a Phylax monitor which accepts int data, if it was instantiated.
    function writeDataPointInt(
        string memory chartName,
        int64 value,
        Label[] memory labels
    ) public {
        emit PhylaxWriteIntMonitor(chartName, value, labels);
    }
}
