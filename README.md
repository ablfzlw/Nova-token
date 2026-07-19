# Nova Token (NV)

A feature-rich ERC20 token built with Solidity and Foundry.

Nova Token is an ERC20 smart contract with additional security and management features such as:

- Transaction tax system
- Treasury fee collection
- Maximum transaction limit
- Address blacklist
- Pausable transfers
- ERC20 Permit support
- ERC1363 support
- Owner controlled minting
- Token staking and unstaking

---

## Features

### ERC20 Standard

- Name: `Nova`
- Symbol: `NV`
- Decimals: `18`
- Initial Supply: `1,000,000 NV`

---

### Tax System

Every transfer includes a configurable tax.

Default tax:

```
2%
```

Example:

```
Transfer: 100 NV

Receiver gets: 98 NV
Treasury gets: 2 NV
```

The owner can change the tax rate:

```solidity
setTax(uint256 newTax)
```

Maximum allowed tax:

```
10%
```

---

### Treasury

A treasury address receives collected transaction fees.

The treasury address is set during deployment.

---

### Transaction Limit

The contract includes a maximum transfer limit.

Default:

```
1000 NV
```

Transfers above this amount will revert.

---

### Blacklist System

The owner can block addresses from sending or receiving tokens.

Example:

```solidity
setBlacklist(address user, bool value)
```

Blacklisted addresses cannot transfer tokens.

---

### Minting

Only the owner can mint new tokens.

```solidity
mint(address to, uint256 amount)
```

---

### Staking

Users can stake their tokens inside the contract.

Stake:

```solidity
stake(uint256 amount)
```

Unstake:

```solidity
unstake(uint256 amount)
```

The contract tracks each user's staked balance.

---

## Security Features

Implemented using OpenZeppelin contracts:

- ERC20
- ERC20Pausable
- ERC20Permit
- ERC1363
- Ownable

Security mechanisms:

- Owner access control
- Transfer pause protection
- Blacklist checks
- Maximum transaction size protection
- Safe OpenZeppelin ERC20 implementation

---

# Project Structure

```
my-token/
│
├── src/
│   └── Token.sol
│
├── test/
│   └── Token.t.sol
│
├── script/
│
├── lib/
│
├── foundry.toml
│
└── README.md
```

---

# Requirements

Install Foundry:

https://book.getfoundry.sh/getting-started/installation

Check installation:

```shell
forge --version
```

---

# Installation

Clone the repository:

```shell
git clone <repository-url>
```

Enter project directory:

```shell
cd my-token
```

Install dependencies:

```shell
forge install
```

---

# Development

## Build

Compile contracts:

```shell
forge build
```

---

## Test

Run all tests:

```shell
forge test
```

Verbose output:

```shell
forge test -vvv
```

Current test status:

```
11 tests passed
0 failed
```

---

## Format

Format Solidity code:

```shell
forge fmt
```

---

## Gas Snapshot

Generate gas reports:

```shell
forge snapshot
```

---

# Local Blockchain

Start a local Ethereum node:

```shell
anvil
```

---

# Deployment

Deploy using Foundry scripts:

```shell
forge script script/Token.s.sol:TokenScript \
--rpc-url <your_rpc_url> \
--private-key <your_private_key> \
--broadcast
```

---

# Cast

Interact with contracts using Cast:

```shell
cast <subcommand>
```

Examples:

```shell
cast call <contract_address> <function>
```

```shell
cast send <contract_address> <function>
```

---

# Testing Details

The test suite covers:

✅ Initial supply  
✅ Token name and symbol  
✅ Owner minting  
✅ Access control  
✅ Transfer tax  
✅ Treasury fee collection  
✅ Blacklist protection  
✅ Tax updates  
✅ Transaction limit  
✅ Staking  
✅ Unstaking  
✅ Staking validation

---

# Technology Stack

- Solidity `^0.8.28`
- Foundry
- Forge
- OpenZeppelin Contracts
- Ethereum Virtual Machine (EVM)

---

# Foundry Toolkit

Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.

Foundry consists of:

- **Forge**: Ethereum testing framework.
- **Cast**: Tool for interacting with EVM contracts and chain data.
- **Anvil**: Local Ethereum development node.
- **Chisel**: Solidity REPL.

Documentation:

https://book.getfoundry.sh/

---

# License

This project is licensed under the MIT License.
