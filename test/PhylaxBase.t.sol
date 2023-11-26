// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import { PhylaxBase } from "../src/PhylaxBase.sol";

contract PhylaxBaseTest is PhylaxBase {
  uint256 sepolia;

  function setUp() public {
    assert(!phylax_setup);
    sepolia = enableChain("sepolia");
  }

  function test_fork() public chain(sepolia) {
    assert(block.number != 0);
  }

  function test_phylax_setup() public view {
    assert(phylax_setup);
  }
}
