// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import {PhylaxBase} from "./PhylaxBase.sol";
import {Phylax} from "./Phylax.sol";

/// @title PhylaxCharts
/// @dev Base contract for all Phylax charts contracts.
abstract contract PhylaxCharts is PhylaxBase {
    /// @dev Array of active charts
    StorageChart[] public phylaxCharts;
    /// @dev Mapping of chart name by chart data type to check name uniquness 
    // and correct incoming data points
    mapping(string => StorageChart) public chartByName;

    /// @notice The chart configuration struct
    /// @dev Can be exported to create a monitor or chart for the alert, 
    /// which can then be populated with data points
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

    /// @notice The data point type enum for describing the type of data point you will create.
    enum DataPointType {
        Uint,
        Int,
        String
    }

    /// @notice Modifier to enforce if a chart name is unique.
    modifier uniqueChartName(string memory chartName) {
        require(bytes(chartByName[chartName].chartName).length == 0, "Chart already exists");
        _;
    }

    /// @notice Modifier to setup charts automatically at the end of a function.
    /// @dev This modifier is particularly useful when used in the setUp() function of an alert test.
    /// Charts cannot be made anywhere else but there, so setting them up in that spot is very convenient.
    modifier setupCharts() {
        _;
        initCharts();
    }

    /// @dev The function for establishing charts manually, in case there was a need you needed your
    // charts returned to you.
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

    /// @notice This function will setup a chart with the given parameters 
    /// and sets it up in the Phylax GUI if executed in the setUp() function.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart, which will display on the y-axis
    /// @param visualization The visualization of the chart
    /// @param dataPointType The data point type of the chart
    /// @param labels The labels of the chart
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

    /// @notice This function will setup a chart with the given parameters 
    /// and sets it up in the Phylax GUI if executed in the setUp() function.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart, which will display on the y-axis
    /// @param visualization The visualization of the chart
    /// @param dataPointType The data point type of the chart
    function createChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        Visualisation visualization,
        DataPointType dataPointType
    ) public uniqueChartName(chartName) {
        createChart(chartName, description, unitLabel, visualization, dataPointType, new Label[](0));
    }

    /// @notice This function create multiple charts that will be overlayed on top of each other by default.
    /// @param overlayKey The key that will be used to uniquely identify
    /// a set of charts that should be overlayed on top of each other.
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the charts, which will display on the y-axis
    /// @param visualization The visualization of the charts
    /// @param dataPointType The data point type of the charts
    /// @param labels The labels of the charts
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

    /// @notice This function create multiple charts that will be overlayed on top of each other by default.
    /// @param overlayKey The key that will be used to uniquely identify
    /// a set of charts that should be overlayed on top of each other.
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the charts, which will display on the y-axis
    /// @param visualization The visualization of the charts
    /// @param dataPointType The data point type of the charts
    function createMultiChart(
        string memory overlayKey,
        string memory description,
        string memory unitLabel,
        Visualisation visualization,
        DataPointType dataPointType,
        string[] memory chartNames
    ) public {
        createMultiChart(overlayKey, description, unitLabel, visualization, dataPointType, new Label[](0), chartNames);
    }

    /// @notice This function create a line chart with the given parameters.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart on the y-axis
    /// @param dataPointType The data point type of the chart
    /// @param labels The labels of the chart
    function createLineChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        DataPointType dataPointType,
        Label[] memory labels
    ) public {
        createChart(chartName, description, unitLabel, Visualisation.Line, dataPointType, labels);
    }

    /// @notice This function create a line chart with the given parameters.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart on the y-axis
    /// @param dataPointType The data point type of the chart
    function createLineChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        DataPointType dataPointType
    ) public {
        createChart(chartName, description, unitLabel, Visualisation.Line, dataPointType);
    }

    /// @notice This function create a gauge chart with the given parameters.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart on the y-axis
    /// @param dataPointType The data point type of the chart
    /// @param labels The labels of the chart
    function createGaugeChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        DataPointType dataPointType,
        Label[] memory labels
    ) public {
        createChart(chartName, description, unitLabel, Visualisation.Gauge, dataPointType, labels);
    }

    /// @notice This function create a gauge chart with the given parameters.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart on the y-axis
    /// @param dataPointType The data point type of the chart
    function createGaugeChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        DataPointType dataPointType
    ) public {
        createChart(chartName, description, unitLabel, Visualisation.Gauge, dataPointType);
    }

    /// @notice This function create a table chart with the given parameters.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart on the y-axis
    /// @param labels The labels of the chart
    function createTableChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        Label[] memory labels
    ) public {
        createChart(chartName, description, unitLabel, Visualisation.Table, DataPointType.String, labels);
    }

    /// @notice This function create a table chart with the given parameters.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart on the y-axis
    function createTableChart(
        string memory chartName,
        string memory description,
        string memory unitLabel
    ) public {
        createChart(chartName, description, unitLabel, Visualisation.Table, DataPointType.String);
    }

    /// @notice This function create a bar chart with the given parameters.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart on the y-axis
    /// @param dataPointType The data point type of the chart
    /// @param labels The labels of the chart
    function createBarChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        DataPointType dataPointType,
        Label[] memory labels
    ) public {
        createChart(chartName, description, unitLabel, Visualisation.Bar, dataPointType, labels);
    }

    /// @notice This function create a bar chart with the given parameters.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart on the y-axis
    /// @param dataPointType The data point type of the chart
    function createBarChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        DataPointType dataPointType
    ) public {
        createChart(chartName, description, unitLabel, Visualisation.Bar, dataPointType);
    }

    /// @notice This function creates a heatmap chart with the given parameters.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart on the y-axis
    /// @param dataPointType The data point type of the chart
    /// @param labels The labels of the chart
    function createHeatmapChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        DataPointType dataPointType,
        Label[] memory labels
    ) public {
        createChart(chartName, description, unitLabel, Visualisation.Heatmap, dataPointType, labels);
    }

    /// @notice This function creates a heatmap chart with the given parameters.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart on the y-axis
    /// @param dataPointType The data point type of the chart
    function createHeatmapChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        DataPointType dataPointType
    ) public {
        createChart(chartName, description, unitLabel, Visualisation.Heatmap, dataPointType);
    }

    /// @notice This function creates a last value chart with the given parameters.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart on the y-axis
    /// @param dataPointType The data point type of the chart
    /// @param labels The labels of the chart
    function createLastValueChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        DataPointType dataPointType,
        Label[] memory labels
    ) public {
        createChart(chartName, description, unitLabel, Visualisation.LastValue, dataPointType, labels);
    }

    /// @notice This function creates a last value chart with the given parameters.
    /// @param chartName The name of the chart
    /// @param description The description of the chart
    /// @param unitLabel The unit label of the chart on the y-axis
    /// @param dataPointType The data point type of the chart
    function createLastValueChart(
        string memory chartName,
        string memory description,
        string memory unitLabel,
        DataPointType dataPointType
    ) public {
        createChart(chartName, description, unitLabel, Visualisation.LastValue, dataPointType);
    }

    function writeToChart(string memory chartName, uint64 value, Label[] memory labels) public {
        require(chartByName[chartName].dataPointType == DataPointType.Uint, "Invalid dataPointType");
        writeDataPointUint(chartName, value, labels);
    }

    function writeToChart(string memory chartName, uint64 value) public {
        require(chartByName[chartName].dataPointType == DataPointType.Uint, "Invalid dataPointType");
        writeToChart(chartName, value, new Label[](0));
    }

    function writeToChart(string memory chartName, int64 value, Label[] memory labels) public {
        require(chartByName[chartName].dataPointType == DataPointType.Int, "Invalid dataPointType");
        writeDataPointInt(chartName, value, labels);
    }

    function writeToChart(string memory chartName, int64 value) public {
        require(chartByName[chartName].dataPointType == DataPointType.Int, "Invalid dataPointType");
        writeToChart(chartName, value, new Label[](0));
    }

    function writeToChart(string memory chartName, address value, Label[] memory labels) public {
        require(chartByName[chartName].dataPointType == DataPointType.String, "Invalid dataPointType");
        writeDataPointString(chartName, vm.toString(value), labels);
    }

    function writeToChart(string memory chartName, address value) public {
        require(chartByName[chartName].dataPointType == DataPointType.String, "Invalid dataPointType");
        writeDataPointString(chartName, vm.toString(value), new Label[](0));
    }      
       

    function writeToChart(string memory chartName, string memory value, Label[] memory labels) public {
        require(chartByName[chartName].dataPointType == DataPointType.String, "Invalid dataPointType");
        writeDataPointString(chartName, value, labels);
    }

    function writeToChart(string memory chartName, string memory value) public {
        require(chartByName[chartName].dataPointType == DataPointType.String, "Invalid dataPointType");
        writeDataPointString(chartName, value, new Label[](0));
    }

    function writeToChart(string memory chartName, bytes32 value, Label[] memory labels) public {
        require(chartByName[chartName].dataPointType == DataPointType.String, "Invalid dataPointType");
        writeDataPointString(chartName, vm.toString(value), labels);
    }

    function writeToChart(string memory chartName, bytes32 value) public {
        require(chartByName[chartName].dataPointType == DataPointType.String, "Invalid dataPointType");
        writeDataPointString(chartName, vm.toString(value), new Label[](0));
    }

    function writeToChart(string memory chartName, bytes memory value, Label[] memory labels) public {
        require(chartByName[chartName].dataPointType == DataPointType.String, "Invalid dataPointType");
        writeDataPointString(chartName, vm.toString(value), labels);
    }

    function writeToChart(string memory chartName, bytes memory value) public {
        require(chartByName[chartName].dataPointType == DataPointType.String, "Invalid dataPointType");
        writeDataPointString(chartName, vm.toString(value), new Label[](0));
    }
}