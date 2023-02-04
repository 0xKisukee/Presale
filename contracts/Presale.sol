// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./sources/IERC20.sol";
import "./sources/MerkleProof.sol";

contract Presale {
    bytes32 public merkleRoot =
        0x527eb783f2cd30e8440dd531310954142f9af00d860f09a1dcae4b0be4bd4d3d;

    uint public publicPrice;
    uint public privatePrice;
    uint public maxAlloc;

    address public owner;
    address public token;
    address public usdc;

    bool public presaleIsOpen;

    mapping(address => bool) public whitelisted;
    mapping(address => uint) public alloc;

    constructor(
        uint _publicPrice,
        uint _privatePrice,
        uint _maxAlloc,
        address _token,
        address _usdc
    ) {
        owner = msg.sender;
        publicPrice = _publicPrice;
        privatePrice = _privatePrice;
        maxAlloc = _maxAlloc;
        token = _token;
        usdc = _usdc;
    }

    function enterPublic(uint _tokenAmount) public {
        require(_tokenAmount > 0, "Wrong value");
        require(presaleIsOpen == true, "Presale is closed");
        require(
            alloc[msg.sender] + _tokenAmount <= maxAlloc,
            "Max alloc reached"
        );

        uint price = _tokenAmount * publicPrice;
        IERC20(usdc).transferFrom(msg.sender, address(this), price);
        alloc[msg.sender] += _tokenAmount;
    }

    function enterPrivate(
        uint _tokenAmount,
        bytes32[] calldata _merkleProof
    ) public onlyWhitelisted {
        require(_tokenAmount > 0, "Wrong value");
        require(presaleIsOpen == true, "Presale is closed");
        require(
            alloc[msg.sender] + _tokenAmount <= maxAlloc,
            "Max alloc reached"
        );

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify(_merkleProof, merkleRoot, leaf),
            "Invalid proof"
        );

        uint price = _tokenAmount * privatePrice;
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
