pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GeoToken is ERC20 {
    constructor() ERC20("GeoToken", "GEO") {
        _mint(msg.sender, 1000000 * 10**18); // Mint 1,000,000 tokens for the contract deployer
    }
}