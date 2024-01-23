// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./CREATE3.sol";
import "./OmniToken.sol";

contract OmniFactory {
    function deployToken(
        string memory _name,
        string memory _symbol,
        uint8 _sharedDecimals,
        address _lzEndpoint,
        address owner
    ) public payable returns (address) {
        bytes memory constructorArgs = abi.encode(
            _name,
            _symbol,
            _sharedDecimals,
            _lzEndpoint,
            owner
        );

        return
            CREATE3.deploy(
                keccak256(abi.encodePacked(_name, _symbol)),
                abi.encodePacked(type(OmniToken).creationCode, constructorArgs),
                msg.value
            );
    }
}
