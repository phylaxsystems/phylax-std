// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {PhylaxBase} from "../src/PhylaxBase.sol";
import {console} from "forge-std/console.sol";

contract PhylaxBaseTest is PhylaxBase {
    uint256 sepolia;

    function setUp() public {
        assert(address(ph) == address(0));
        sepolia = enableChain("sepolia");
    }

    function test_modifierForks() public chain(sepolia) {
        assert(block.number != 0);
    }

    function test_phylaxContractIsSetup() public view {
        assert(address(ph) != address(0));
    }

    function test_chainsArrayCorrect() public view {
        assert($activeChains.length == 1);
        assert($activeChains[0] == sepolia);
    }

    function test_exportNotRevert() public {
        ph.export("test_key", "test_value");
    }

    function test_importNotRevert() public view {
        ph.importContext("test_key");
    }
}
