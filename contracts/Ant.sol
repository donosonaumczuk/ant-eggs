//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Ant is ERC721 {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Ant", "ANT") {}

    function mint(address _toAccount) public returns (uint256) {
        _tokenIds.increment();
        uint256 antId = _tokenIds.current();
        _mint(_toAccount, antId);
        return antId;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return symbol();
    }
}