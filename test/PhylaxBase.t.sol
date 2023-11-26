// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import { PhylaxBase } from "../src/PhylaxBase.sol";

contract PhylaxBaseTest is PhylaxBase {
  uint256 sepolia;

  function setUp() public {
    assert(!$phylax_setup);
    sepolia = enableChain("sepolia");
  }

  function testChainModifier() public chain(sepolia) {
    assert(block.number != 0);
  }

  function testPhylaxSetup() public view {
    assert($phylax_setup);
  }

  function testChainsArray() public view {
    assert($activeChains.length == 1);
    assert($activeChains[0] == sepolia);
  }
}
