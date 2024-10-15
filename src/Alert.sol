// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import {Test} from "forge-std/Test.sol";
import {PhylaxBase} from "./PhylaxBase.sol";
import {PhylaxNotification} from "./PhylaxNotification.sol";
import {PhylaxCharts} from "./PhylaxCharts.sol";

/// @title Alert
/// @dev Base contract for all Phylax alert contracts.
abstract contract Alert is PhylaxBase, PhylaxCharts, PhylaxNotification, Test {

}
