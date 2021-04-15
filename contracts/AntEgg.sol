//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract AntEgg is ERC20 {

    using SafeMath for uint256;

    uint256 constant EGG_ETH_PRICE = 1 * 10 ** 16;

    constructor() ERC20("Ant Egg", "EGG") {}

    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    // function mint(uint256 _amount) payable external {
    //     uint256 requiredEth = _amount.mul(EGG_ETH_PRICE);
    //     require(msg.value >= requiredEth, "Insufficent ETH to mint the desired amount of EGG");
    //     require(payable(msg.sender).send(msg.value.sub(requiredEth)));
    //     _mint(msg.sender, _amount);
    // }

    function mint(uint256 _amount) payable external {
        require(msg.value == _amount.mul(EGG_ETH_PRICE), "Invalid ETH to mint the desired amount of EGG");
        _mint(msg.sender, _amount);
    }
}
