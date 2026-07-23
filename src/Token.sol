// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC1363} from "@openzeppelin/contracts/token/ERC20/extensions/ERC1363.sol";

/// @title Nova Token Implementation
/// @author A
/// @notice An advanced ERC20 token featuring tax, staking, blacklisting, and governance permit capabilities.
contract Token is ERC20, ERC20Pausable, ERC20Permit, Ownable, ERC1363 {

    // Custom Errors
    error InvalidTreasury();
    error BlacklistedUser();
    error NotEnoughStaked();
    error TaxTooHigh();

    /// @notice Emitted when the tax percentage is updated
    /// @param oldTax The previous tax percentage
    /// @param newTax The new tax percentage
    event TaxUpdated(uint256 indexed oldTax, uint256 indexed newTax);

    /// @notice The current transfer tax percentage
    uint256 public tax = 2;

    /// @notice The max transfer tax percentage
    uint256 public constant MAX_TAX = 10;

    /// @notice The address of the protocol treasury receiving tax fees
    address public treasury;

    /// @notice Mapping to track blacklisted user addresses
    mapping(address => bool) public blacklisted;

    /// @notice Mapping to track staked token balances of users
    mapping(address => uint256) public staked;

    constructor(address _treasury) ERC20("Nova", "NV") Ownable(msg.sender) ERC20Permit("Nova") {
        if(_treasury == address(0)) revert InvalidTreasury();
        treasury = _treasury;
        _mint(msg.sender, 1_000_000 * 1e18);
    }

    /// @notice Creates new tokens and assigns them to the specified address
    /// @param to The recipient address of the minted tokens
    /// @param amount The quantity of tokens to mint
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /// @notice Updates the blacklist status of a user
    /// @param user The target user address
    /// @param value The blacklist status boolean to set
    function setBlacklist(address user, bool value) external onlyOwner {
        blacklisted[user] = value;
    }

    /// @notice Internal transfer logic overriding standard ERC20 transfers to apply taxes and checks
    /// @param from The sender address
    /// @param to The recipient address
    /// @param value The amount of tokens to transfer
    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Pausable) whenNotPaused {
        if(blacklisted[from] && blacklisted[to]) revert BlacklistedUser();

        if (from == address(0) || to == address(0)) {
            super._update(from, to, value);
            return;
        }

        uint256 fee = (value * tax) / 100;
        uint256 sendAmount = value - fee;

        super._update(from, treasury, fee);
        super._update(from, to, sendAmount);
    }

    /// @notice Stakes a specific amount of tokens into the contract
    /// @param amount The quantity of tokens to stake
    function stake(uint256 amount) external {
        _transfer(msg.sender, address(this), amount);
        staked[msg.sender] += amount;
    }

    /// @notice Unstakes a specific amount of previously staked tokens
    /// @param amount The quantity of tokens to unstake
    function unstake(uint256 amount) external {
        if(staked[msg.sender] < amount) revert NotEnoughStaked();

        staked[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount);
    }

    /// @notice Updates the transaction tax rate
    /// @param newTax The new tax rate percentage (max 10)
    function setTax(uint256 newTax) external onlyOwner {
        if(newTax > MAX_TAX) revert TaxTooHigh();
        emit TaxUpdated(tax, newTax);
        tax = newTax;
    }
}
