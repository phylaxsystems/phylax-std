// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {console} from "forge-std/console.sol";
import {CommonBase} from "forge-std/Base.sol";
import {PhylaxVM} from "./PhylaxVM.sol";

/// @title Vm-like interface for Phylax
/// @dev It includes cheatcodes that are available in the phylax fork of foundry, but have not been upstreamed
contract Phylax is CommonBase {
    /// @dev The internal cheatcode address that is used by forge
    PhylaxVM internal constant _ph = PhylaxVM(VM_ADDRESS);
    bool internal _phylaxRun;

    constructor() {
        try _ph.importContext("activity.task_name") {
            _phylaxRun = true;
        } catch {
            _phylaxRun = false;
        }
    }

    /// @notice Export a name/value pair to Phylax
    /// @dev It's exposed via the API and if it's numerical, via the prometheus endpoint as well.
    /// @param name The name of the value to export
    /// @param value The value to export
    function export(string memory name, string memory value) external {
        if (!_phylaxRun) {
            informUser;
            return;
        }
        _ph.export(name, value);
    }

    function importContext(string memory key) public view returns (bytes memory) {
        if (!_phylaxRun) {
            informUser;
            return new bytes(32);
        }
        return _ph.importContext(key);
    }

    function informUser() internal view {
        console.log("Phylax cheatcodes do nothing when executed by vanilla foundry");
    }

    function importContextString(string memory key) external view returns (string memory) {
        return abi.decode(importContext(key), (string));
    }

    function importContextUint(string memory key) external view returns (uint256) {
        return abi.decode(importContext(key), (uint256));
    }

    function importContextInt(string memory key) external view returns (int256) {
        return abi.decode(importContext(key), (int256));
    }

    function importContextAddress(string memory key) external view returns (address) {
        return abi.decode(importContext(key), (address));
    }

    function importContextBytes32(string memory key) external view returns (bytes32) {
        return abi.decode(importContext(key), (bytes32));
    }

    function importContextBytes(string memory key) external view returns (bytes memory) {
        return abi.decode(importContext(key), (bytes));
    }
}
