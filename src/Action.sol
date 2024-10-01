// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {Script} from "forge-std/Script.sol";
import {PhylaxBase} from "./PhylaxBase.sol";

/// @title Action
/// @dev Base contract for all Phylax action contracts.
abstract contract Action is PhylaxBase, Script {}
