// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {Test} from "forge-std/Test.sol";
import {Phylax} from "./Phylax.sol";

// Base contract for all Phylax alert contracts.
abstract contract Alert is Test {
    Phylax internal constant phylax = Phylax(VM_ADDRESS);
}
