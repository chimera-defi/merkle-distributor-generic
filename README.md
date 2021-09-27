# Info

This is based on the uniswap merkle distributor with the following changes:
- Change the base to a generic merkle distributor to allow it to be used with more than just erc20  
- New TimedClawback contract to allow owner to retrieve unclaimed tokens in the airdrop after a set timeframe  
- Add a way to change the merkle root to allow us to reuse the contract  
- Add an example implementation that does the same as the original erc20 merkle distributor with the additional clawback and merkle root update functionality  
- Update sol to 0.6.12 to allow release on metis if needed
# merkle-distributor

[![Tests](https://github.com/Uniswap/merkle-distributor/workflows/Tests/badge.svg)](https://github.com/Uniswap/merkle-distributor/actions?query=workflow%3ATests)
[![Lint](https://github.com/Uniswap/merkle-distributor/workflows/Lint/badge.svg)](https://github.com/Uniswap/merkle-distributor/actions?query=workflow%3ALint)

# Local Development

The following assumes the use of `node@>=10`.

## Install Dependencies

`yarn`

## Compile Contracts

`yarn compile`

## Run Tests

`yarn test`
