//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./AntEgg.sol";

contract Ant is ERC721 {

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;

    AntEgg antEgg;
    address owner;
    bool antEggContractAddressSet;
    mapping(uint256 => uint256) lastEggCreationTimestampByAnt;
    mapping(uint256 => uint256) eggsLeftToBeCreatedByAnt;

    constructor() ERC721("Ant", "ANT") {
        owner = msg.sender;
    }

    /**
     * @dev Base URI for computing {tokenURI}
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return symbol();
    }

    /**
     * @dev Mints one ANT to the sender in exchange of an EGG. Returns the ANT ID.
     *
     * Requirements:
     *
     * - `sender` must have a balance of at least one EGG.
     */
    function mint() external returns (uint256) {
        require(antEgg.balanceOf(msg.sender) >= 1, "You need one EGG to mint one ANT");
        tokenIds.increment();
        uint256 antId = tokenIds.current();
        _mint(msg.sender, antId);
        lastEggCreationTimestampByAnt[antId] = 0;
        eggsLeftToBeCreatedByAnt[antId] = uint256(blockhash(block.number)) % 100;
        antEgg.burn(msg.sender, 1);
        return antId;
    }

    /**
     * @dev Mints one EGG to the sender, reducnig in one the capacity of the given ANT to mint future EGG.
     * ANT can die, and be burned, after minting an EGG. Returns a bool value indicating if ANT still alive.
     *
     * Requirements:
     *
     * - `sender` must be the owner of the given ANT.
     * - the given ANT must have the capacity to create at least an EGG.
     * - at least 10 minutes must be elapsed from the last EGG minted from the given ANT.
     */
    function mintEgg(uint256 _antId) external returns (bool) {
        require(msg.sender == ownerOf(_antId), "You must be the ANT owner to use it to mint an EGG");
        require(eggsLeftToBeCreatedByAnt[_antId] > 0, "This ANT has already minted all its EGG");
        require(block.timestamp - lastEggCreationTimestampByAnt[_antId] > 10 minutes);
        antEgg.mintFromAnt(msg.sender, 1);
        lastEggCreationTimestampByAnt[_antId] = block.timestamp;
        eggsLeftToBeCreatedByAnt[_antId]--;
        bool antStillAlive = block.number % 100 != _antId % 100;
        if (!antStillAlive) {
            _burn(_antId);
        }
        return antStillAlive;
    }

    /**
     * @dev Sets `_antEgg` as the EGG address contract. 
     *
     * Requirements:
     *
     * - only callable by owner.
     * - can be set only once.
     */
    function setEggContract(AntEgg _antEgg) external onlyOwner() {
        require(!antEggContractAddressSet, "EGG contract address already set");
        antEgg = _antEgg;
        antEggContractAddressSet = true;
    }
}
