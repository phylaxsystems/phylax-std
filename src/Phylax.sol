// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {console} from "forge-std/console.sol";
import {CommonBase} from "forge-std/Base.sol";

/// @title Vm-like interface for Phylax
/// @dev It includes cheatcodes that are available in the phylax fork of foundry, but have not been upstreamed
contract Phylax is CommonBase {
    /// @dev The internal cheatcode address that is used by forge
    Phylax internal constant _ph = Phylax(VM_ADDRESS);
    bool internal _phylaxRun;

    event PhylaxExport(string key, string value);

    constructor() {
        try _ph.importContext("") {
            _phylaxRun = true;
        } catch {
            _phylaxRun = false;
        }
    }

    /// @notice Export a name/value pair to Phylax
    /// @dev It's exposed via the API and if it's numerical, via the prometheus endpoint as well.
    /// @param key The key of the value to export
    /// @param value The value to export
    function export(string memory key, string memory value) external requirePhoundry {
        emit PhylaxExport(key, value);
    }

    function importContext(string memory key) public view requirePhoundry returns (bytes memory) {
        if (!_phylaxRun) {
            informUser;
            return new bytes(32);
        }
        return _ph.importContext(key);
    }

    function informUser() internal view {
        console.log(
            "Phylax cheatcodes require 'Phoundry', Phylax's fork of Foundry. The cheatcodes do nothing in vanilla Forge."
        );
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

    modifier requirePhoundry() {
        if (!_phylaxRun) {
            console.log(
                "Phylax cheatcodes require 'Phoundry', Phylax's fork of Foundry. The cheatcodes do nothing in vanilla Forge."
            );
        }
        _;
    }
}
