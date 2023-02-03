// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./sources/ERC20.sol";

contract USDC is ERC20("USDC", "USDC Token") {
    constructor() {
        _mint(msg.sender, 1_000_000 * 1e18);
    }
}
