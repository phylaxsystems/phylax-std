// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {console} from "forge-std/console.sol";
import {CommonBase, Vm} from "forge-std/Base.sol";

/// @title Vm-like interface for Phylax
/// @dev It includes cheatcodes that are available in the phylax fork of foundry, but have not been upstreamed
interface Phylax is Vm {
/// Add additional cheatcodes here...
}
