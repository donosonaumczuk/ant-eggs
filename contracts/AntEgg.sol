//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Ant.sol";

contract AntEgg is ERC20 {

    using SafeMath for uint256;

    modifier onlyAntContract() {
        require(msg.sender == address(ant), "Only callable from ANT contract");
        _;
    }

    uint256 constant EGG_ETH_PRICE = 1 * 10 ** 16;

    Ant ant;

    constructor(Ant _ant) ERC20("Ant Egg", "EGG") {
        ant = _ant;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     */
    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    /**
     * @dev Mints `_amount` EGG to the sender in exchange of ETH.
     *
     * Requirements:
     *
     * - `value` must be equals to `_amount` multiplied by 0.01 ETH.
     */
    function mint(uint256 _amount) payable external {
        require(msg.value == _amount.mul(EGG_ETH_PRICE), "Invalid ETH to mint the desired amount of EGG");
        _mint(msg.sender, _amount);
    }

    /**
     * @dev Burns `_amount` EGG from `_fromAccount` address.
     *
     * Requirements:
     *
     * - only callable by ANT contract.
     */
    function burn(address _fromAccount, uint256 _amount) external onlyAntContract() {
        _burn(_fromAccount, _amount);
    }

    /**
     * @dev Mints `_amount` EGG to `_toAccount` address.
     *
     * Requirements:
     *
     * - only callable by ANT contract.
     */
    function mintFromAnt(address _toAccount, uint256 _amount) external onlyAntContract() {
        _mint(_toAccount, _amount);
    }
}
