// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {Test} from "forge-std/Test.sol";
import {PhylaxBase} from "./PhylaxBase.sol";

/// @title Alert
/// @dev Base contract for all Phylax alert contracts.
abstract contract Alert is PhylaxBase, Test {}
