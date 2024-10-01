// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import {PhylaxBase} from "./PhylaxBase.sol";
import {console} from "forge-std/console.sol";
import {Phylax} from "./Phylax.sol";

/// @title PhylaxCharts
/// @dev Base contract for all Phylax charts contracts.
abstract contract PhylaxCharts is PhylaxBase {
    /// @dev Array of active charts
    StorageChart[] public phylaxCharts;
    /// @dev Mapping of chart name by chart data type to check name uniquness 
    // and correct incoming data points
    mapping(string => StorageChart) public chartByName;

    struct Chart {
        string chartName;
        string description;
        string unitLabel;
        Visualisation visualization;
        DataPointType dataPointType;
        Label[] labels;
    }

    /// @dev The chart struct without the Label array preventing it from
    /// being used in arrays or mappings. 
    struct StorageChart {
        string chartName;
        string description;
        string unitLabel;
        Visualisation visualization;
        DataPointType dataPointType;
        string[] labelKeys;
        string[] labelValues;
    }

    /// @notice The visualization enum for describing the type of chart you will create.
    /// @dev This enum is used to create charts in the Phylax GUI and in the telemetry exports.
    enum Visualisation {
        Bar,
        Line,
        Heatmap,
        Gauge,
        Table,
        LastValue
    }

    enum DataPointType {
        Uint,
        Int,
        String
    }

    modifier uniqueChartName(string memory chartName) {
        require(bytes(chartByName[chartName].chartName).length == 0, "Chart already exists");
        _;
    }

    // function charts() public virtual;
    modifier setupCharts() {
        _;
        initCharts();
    }


    function initCharts() public virtual returns (PhylaxCharts.Chart[] memory memCharts) {
        memCharts = new PhylaxCharts.Chart[](PhylaxCharts.phylaxCharts.length);
        
        for (uint256 i; i < phylaxCharts.length; i++) {

            Label[] memory labels = new Label[](phylaxCharts[i].labelKeys.length);

            for (uint256 j; i < phylaxCharts[i].labelKeys.length; j++) {
                labels[j] = Label({key: phylaxCharts[i].labelKeys[j], value: phylaxCharts[i].labelValues[j]});
            }

            Chart memory chart = Chart({
                chartName: phylaxCharts[i].chartName,
                description: phylaxCharts[i].description,
                unitLabel: phylaxCharts[i].unitLabel,
                visualization: phylaxCharts[i].visualization,
                dataPointType: phylaxCharts[i].dataPointType,
                labels: labels
            });

            memCharts[i] = chart;
            createChartMonitor(
                phylaxCharts[i].chartName,
                phylaxCharts[i].description,
                phylaxCharts[i].unitLabel,
                uint8(phylaxCharts[i].visualization),
                uint8(phylaxCharts[i].dataPointType),
                labels
            );
        }
    }

    function createChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        Visualisation visualization,
        DataPointType dataPointType,
        Label[] memory labels
    ) public uniqueChartName(chartName) {
        string[] memory labelKeys = new string[](labels.length);
        string[] memory labelValues = new string[](labels.length);

        for (uint256 i = 0; i < labels.length; i++) {
            labelKeys[i] = labels[i].key;
            labelValues[i] = labels[i].value;
        }

        StorageChart memory newChart = PhylaxCharts.StorageChart({
            chartName: chartName,
            description: description,
            unitLabel: unitLabel,
            visualization: visualization,
            dataPointType: dataPointType,
            labelKeys: labelKeys,
            labelValues: labelValues
        });

        chartByName[chartName] = newChart;
        phylaxCharts.push(newChart);
    }

    function createChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        Visualisation visualization,
        DataPointType dataPointType
    ) public uniqueChartName(chartName) {
        createChart(chartName, description, unitLabel, visualization, dataPointType, new Label[](0));
    }

    function createMultiChart(
        string memory overlayKey,
        string memory description,
        string memory unitLabel,
        Visualisation visualization,
        DataPointType dataPointType,
        Label[] memory labels,
        string[] memory chartNames
    ) public {
        Label[] memory extendedLabels = new Label[](labels.length + 1);
        for (uint256 i = 0; i < labels.length; i++) {
            extendedLabels[i] = labels[i];
        }

        extendedLabels[labels.length] = Label({ key: overlayKey, value: "overlayChartKey" }); 
        
        for (uint256 i = 0; i < chartNames.length; i++) {
            createChart(
                chartNames[i],
                description,
                unitLabel,
                visualization,
                dataPointType,
                labels
            );
        }
    }

}