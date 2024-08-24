# chainlink-brownie-contracts

A minimal repo that is a copy of the npm package [@chainlink/contracts](https://www.npmjs.com/package/@chainlink/contracts). These contracts are taken from the [core chainlink github](https://github.com/smartcontractkit/chainlink), compressed, and deployed to npm. 


## Usage

### Foundry

1. Run this in your projects root directory.

```bash
forge install smartcontractkit/chainlink-brownie-contracts --no-commit
```

2. Then, update your `foundry.toml` to include the following in the `remappings`.

```
remappings = [
  '@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/src/',
]
```

```bash
source .env
forge test --fork-url $SEPOLIA_RPC -vvv
```