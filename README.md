# Phylax Standard Library

![CI status](https://github.com/phylax-systems/phylax-std/actions/workflows/ci.yml/badge.svg)

Phylax Standard Library is a collection of helpful contracts and libraries for use with Phylax. It provides a set of interfaces and contracts to
interact with Phylax and Foundry.

## Install

### Foundry

```bash
forge install phylax-systems/phylax-std
```

### Yarn

```bash
yarn add @phylax-systems/phylax-std
```

and add the following remappings to your project by creating the `remappings.txt`.

```bash
forge-std/=node_modules/forge-std/src/
ds-test/=node_modules/ds-test/src/
```

## Forking

Forking uses Foundry in the background, so you can follow the same best practices:

- Set the RPC url inside the contract
- Set the RPC url in an env variable and then use the relevant Foundry cheatcodes to get it
- Set the RPC url inside `foundry.toml` and use an alias in the contracts

Read more in the [Foundry Fork Testing Docs](https://book.getfoundry.sh/forge/fork-testing?highlight=select#forking-cheatcodes).

## Contracts

### Phylax

This is the main interface for interacting with Phylax. It enables the Phylax-only Foundry cheatcodes, such as `ph.export(string,string)`.

### Action

This is the base contract for all Phylax alert contracts. It provides a constant reference to Phylax and **RE-IMPORTS** `forge-std/Script.sol`.

#### Action Interface

Read the docs at <https://phylax-std.phylax.watch>

#### Action Usage

```Solidity
import { Action } from "phylax-std/Action.sol";

contract PauseProtocol is Action {
    function run() public {
        // pause protocol
        uint256 collateral_left = protocol.collateral_left();
        ph.export("collateral_left", collateral_left);
    }
}
```

### Alert

This is the base contract for all Phylax alert contracts. It provides a constant reference to Phylax and **RE-IMPORTS** `forge-std/Test.sol`.

#### Alert Interface

Read the docs at <https://phylax-std.phylax.watch>

#### Alert Usage

```Solidity
import { Alert } from "phylax-std/Alert.sol";

contract CollateralAlert is Alert {

    uint256 polygon;
    uint256 ethereum;

    uint256 BASELINE_BLOCK = 5000;

    function setUp() public {
        polygon = enableChain(<RPC_URL>);
        ethereum = enableChain(<RPC_URL>, BASELINE_BLOCK);
    }

    function testCollateralPolygon() chain(polygon) public {
        // ...
    }

    function testCollateralPolygonBaseline() chain(ethereum) public {
        // ...
    }
}
```

### License

Phylax Standard Library is offered under either MIT or Apache 2.0.
