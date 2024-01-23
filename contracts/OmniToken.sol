// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {BaseOFTV2} from "@layerzerolabs/solidity-examples/contracts/token/oft/v2/BaseOFTV2.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OmniToken is Ownable, BaseOFTV2, ERC20 {
    uint256 _totalSupply = 1_000_000_000 * 1e18;
    uint internal immutable ld2sdRate;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _sharedDecimals,
        address _lzEndpoint,
        address owner
    ) ERC20(_name, _symbol) BaseOFTV2(_sharedDecimals, _lzEndpoint) Ownable() {
        _transferOwnership(owner);
        _mint(owner, _totalSupply);
        uint8 decimals = decimals();
        require(
            _sharedDecimals <= decimals,
            "OFT: sharedDecimals must be <= decimals"
        );
        ld2sdRate = 10 ** (decimals - _sharedDecimals);
    }

    function token() public view virtual override returns (address) {
        return address(this);
    }

    function circulatingSupply() public view virtual override returns (uint) {
        return totalSupply();
    }

    function _debitFrom(
        address _from,
        uint16,
        bytes32,
        uint _amount
    ) internal virtual override returns (uint) {
        address spender = _msgSender();
        if (_from != spender) _spendAllowance(_from, spender, _amount);
        _burn(_from, _amount);
        return _amount;
    }

    function _creditTo(
        uint16,
        address _toAddress,
        uint _amount
    ) internal virtual override returns (uint) {
        _mint(_toAddress, _amount);
        return _amount;
    }

    function _transferFrom(
        address _from,
        address _to,
        uint _amount
    ) internal virtual override returns (uint) {
        address spender = _msgSender();
        // if transfer from this contract, no need to check allowance
        if (_from != address(this) && _from != spender)
            _spendAllowance(_from, spender, _amount);
        _transfer(_from, _to, _amount);
        return _amount;
    }

    function _ld2sdRate() internal view virtual override returns (uint) {
        return ld2sdRate;
    }
}
