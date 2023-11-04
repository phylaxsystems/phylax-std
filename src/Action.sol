// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {Script} from "forge-std/Script.sol";
import {Phylax} from "./Phylax.sol";

// Base contract for all Phylax alert contracts.
abstract contract Action is Script {
    Phylax internal constant ph = Phylax(VM_ADDRESS);
}
