// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import {PhylaxBase} from "./PhylaxBase.sol";
import {console} from "forge-std/console.sol";
import {Phylax} from "./Phylax.sol";

/// @title PhylaxCharts
/// @dev Base contract for all Phylax charts contracts.
abstract contract PhylaxCharts is PhylaxBase {
    Chart[] public phylaxCharts;
    mapping(string => ChartMapping) public chartDataTypeByName;

    struct Chart {
        string chartName;
        string description;
        string unitLabel;
        Visualisation visualization;
        DataPointType dataPointType;
        Label[] labels;
    }

    struct ChartMapping {
        string chartName;
        DataPointType dataPointType;
    }

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
        require(bytes(chartDataTypeByName[chartName]).length == 0, "Chart already exists");
        _;
    }

    // function charts() public virtual;
    modifier setupCharts() {
        _;
        initCharts();
    }


    function initCharts() public virtual returns (PhylaxCharts.Chart[] memory memCharts) {
        memCharts = new PhylaxCharts.Chart[](phylaxCharts.length);
        
        for (uint256 i; i < phylaxCharts.length; i++) {
            memCharts[i] = phylaxCharts[i];
            ph.createChartMonitor(
                phylaxCharts[i].chartName,
                phylaxCharts[i].description,
                phylaxCharts[i].unitLabel,
                uint8(phylaxCharts[i].visualization),
                uint8(phylaxCharts[i].dataPointType),
                phylaxCharts[i].labels
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
        Chart memory newChart = PhylaxCharts.Chart({
            chartName: chartName,
            description: description,
            unitLabel: unitLabel,
            visualization: visualization,
            dataPointType: dataPointType,
            labels: labels
        });
        ChartMapping memory chartMap = ChartMapping({
            chartName: chartName,
            dataPointType: dataPointType
        });
        chartDataTypeByName[chartName] = chartMap;
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
            extendedLabels[i] = labels[i]
        }

        extendedLabels[labels.length] = Label { key: overlayKey, value: "overlayChartKey" }; 
        
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