// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./sources/IERC20.sol";

contract Presale {
    uint public tokenPrice;
    uint public maxAlloc;

    address public owner;
    address public token;
    address public usdc;

    bool public presaleIsOpen;

    mapping(address => bool) public whitelisted;
    mapping(address => uint) public alloc;

    constructor(
        uint _tokenPrice,
        uint _maxAlloc,
        address _token,
        address _usdc
    ) {
        owner = msg.sender;
        tokenPrice = _tokenPrice;
        maxAlloc = _maxAlloc;
        token = _token;
        usdc = _usdc;
    }

    function enterPublic(uint _tokenAmount) public {
        require(presaleIsOpen == true, "Presale is closed");
        require(
            alloc[msg.sender] + _tokenAmount <= maxAlloc,
            "Max alloc reached"
        );
        uint price = _tokenAmount * tokenPrice;
        IERC20(usdc).transferFrom(msg.sender, address(this), price);
        alloc[msg.sender] += _tokenAmount;
    }

    function enterPrivate(uint _tokenAmount) public onlyWhitelisted {
        require(presaleIsOpen == true, "Presale is closed");
        require(
            alloc[msg.sender] + _tokenAmount <= maxAlloc,
            "Max alloc reached"
        );
        uint price = _tokenAmount * tokenPrice;
        IERC20(usdc).transferFrom(msg.sender, address(this), price);
        alloc[msg.sender] += _tokenAmount;
    }

    function claim() public {
        require(presaleIsOpen == false, "Presale still open");
        require(alloc[msg.sender] > 0, "Nothing to claim");
        IERC20(token).transfer(msg.sender, alloc[msg.sender]);
        alloc[msg.sender] = 0;
    }

    function whitelist(address _user) public onlyOwner {
        whitelisted[_user] = true;
    }

    function openPresale() public onlyOwner {
        presaleIsOpen = true;
    }

    function closePresale() public onlyOwner {
        presaleIsOpen = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    modifier onlyWhitelisted() {
        require(whitelisted[msg.sender] == true, "Caller is not whitelisted");
        _;
    }
}