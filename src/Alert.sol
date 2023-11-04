// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;
pragma experimental ABIEncoderV2;

import {Test} from "forge-std/Test.sol";
import {Phylax} from "./Phylax.sol";

// Base contract for all Phylax alert contracts.
abstract contract Alert is Test {
    Phylax internal constant ph = Phylax(VM_ADDRESS);

    uint256[] activeChains;

    function enableChain(
        string calldata aliasOrUrl
    ) internal returns (uint256) {
        activeChains.push(vm.createFork(aliasOrUrl));
        return activeChains.length - 1;
    }

    modifier chain(uint256 index) {
        ph.export("fork_activated", "");
        vm.selectFork(activeChains[index]);
        _;
    }
}
