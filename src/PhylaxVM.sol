// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

/// @title PhylaxVM
/// @dev This interface defines the methods for interacting with the Phylax Virtual Machine.
interface PhylaxVM {
    /// @notice Exports a key-value pair to the VM context.
    /// @param key The key to be exported.
    /// @param value The value to be associated with the key.
    function export(string memory key, string memory value) external;

    /// @notice Imports a value from the VM context using a key.
    /// @param key The key to use for importing the value.
    /// @return The value associated with the key in the VM context.
    function importContext(string memory key) external view returns (bytes memory);
}
