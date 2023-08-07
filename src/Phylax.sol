// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

// Vm-like interface for Phylax. It includes cheatcodes that are available
// in the phylax fork of foundry, but have bnot been upstreamed
interface Phylax {
    // Export a name/value pairt to Phylax. It's exposed via the API and
    // if it's numerical, via the prometheus endpoint as well.
    function export(string calldata name, string calldata value) external;
}
