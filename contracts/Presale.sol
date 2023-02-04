// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./sources/IERC20.sol";
import "./sources/MerkleProof.sol";

contract Presale {
    bytes32 public merkleRoot =
        0x5e79639e99a5d70ef3e3eed2007297a5afd4dd927af46758d4ca84a6be853b65;

    uint public publicPrice;
    uint public privatePrice;
    uint public maxAlloc;

    address public owner;
    address public token;
    address public stable;

    bool public presaleIsOpen;

    mapping(address => uint) public alloc;

    constructor(
        uint _publicPrice,
        uint _privatePrice,
        uint _maxAlloc,
        address _token,
        address _stable
    ) {
        owner = msg.sender;
        publicPrice = _publicPrice;
        privatePrice = _privatePrice;
        maxAlloc = _maxAlloc;
        token = _token;
        stable = _stable;
    }

    function enterPublic(uint _tokenAmount) public {
        require(_tokenAmount > 0, "Wrong value");
        require(presaleIsOpen == true, "Presale is closed");
        require(
            alloc[msg.sender] + _tokenAmount <= maxAlloc,
            "Max alloc reached"
        );

        uint price = _tokenAmount * publicPrice;
        IERC20(stable).transferFrom(msg.sender, address(this), price);
        alloc[msg.sender] += _tokenAmount;
    }

    function enterPrivate(
        uint _tokenAmount,
        bytes32[] calldata _merkleProof
    ) public {
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
        IERC20(stable).transferFrom(msg.sender, address(this), price);
        alloc[msg.sender] += _tokenAmount;
    }

    function claim() public {
        require(presaleIsOpen == false, "Presale still open");
        require(alloc[msg.sender] > 0, "Nothing to claim");
        IERC20(token).transfer(msg.sender, alloc[msg.sender]);
        alloc[msg.sender] = 0;
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
}
