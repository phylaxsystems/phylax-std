// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import { console } from "forge-std/console.sol";
import { CommonBase } from "forge-std/Base.sol";

/// @title Vm-like interface for Phylax
/// @dev It includes cheatcodes that are available in the phylax fork of foundry, but have not been upstreamed
contract Phylax is CommonBase {
  /// @dev The internal cheatcode address that is used by forge
  Phylax internal constant _ph = Phylax(VM_ADDRESS);

  /// @notice Export a name/value pair to Phylax
  /// @dev It's exposed via the API and if it's numerical, via the prometheus endpoint as well.
  /// @param name The name of the value to export
  /// @param value The value to export
  function export(string memory name, string memory value) external {
    try _ph.export(name, value) {} catch {
      console.log("'ph.export(string,string)' reverted. This is normal if the code was run by vanilla 'forge'");
    }
  }
}
