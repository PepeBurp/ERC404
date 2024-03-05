// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC404} from "./ERC404.sol";

contract Test is Ownable, ERC404 {
    
    string public dataURI;
    string public baseTokenURI;

    string public constant evo5Path1 = "/pokemoonspace/meta/main/evo5/1/";
    string public constant evo5Path2 = "/pokemoonspace/meta/main/evo5/2/";
    string public constant evo5Path3 = "/pokemoonspace/meta/main/evo5/3/";
    string public constant evo5Path4 = "/pokemoonspace/meta/main/evo5/4/";
    string public constant evo5Path5 = "/pokemoonspace/meta/main/evo5/5/";

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 maxTotalSupplyERC721_,
        address initialOwner_,
        address initialMintRecipient_
    ) ERC404(name_, symbol_, decimals_) Ownable(initialOwner_) {
        // Do not mint the ERC721s to the initial owner, as it's a waste of gas.
        _setERC721TransferExempt(initialMintRecipient_, true);
        _mintERC20(initialMintRecipient_, maxTotalSupplyERC721_ * units);
    }

    function setDataURI(string memory _dataURI) public onlyOwner {
        dataURI = _dataURI;
    }

    function setTokenURI(string memory _tokenURI) public onlyOwner {
        baseTokenURI = _tokenURI;
    }

    function tokenURI(uint256 id_) public view override returns (string memory) {
        if (bytes(baseTokenURI).length > 0) {
            return string.concat(baseTokenURI, Strings.toString(id_));
        } else {
            uint8 seed = uint8(bytes1(keccak256(abi.encodePacked(id_))));
            string memory folderPath;
            string memory jsonFileName;
            uint256 lastTransferTimestamp = _getERC721LastTransferTimestamp(id_);

            if (seed <= 255) {
                folderPath = getEvo5Path(lastTransferTimestamp);
                jsonFileName = string.concat(Strings.toString((id_ % 2) + 1), ".json");
            }

            string memory fullURI = string.concat(dataURI, folderPath, jsonFileName);

            return fullURI;
        }
    }

    function getEvo5Path(uint256 lastTransferTimestamp) internal view returns (string memory) {
        if (lastTransferTimestamp == 0 || bytes(evo5Path5).length == 0) {
            return evo5Path1;
        } else if (block.timestamp - lastTransferTimestamp >= 11 minutes) {
            return evo5Path5;
        } else if (block.timestamp - lastTransferTimestamp >= 9 minutes) {
            return evo5Path4;
        } else if (block.timestamp - lastTransferTimestamp >= 7 minutes) {
            return evo5Path3;
        } else if (block.timestamp - lastTransferTimestamp >= 5 minutes) {
            return evo5Path2;
        } else {
            return evo5Path1;
        }
    }
    function setERC721TransferExempt(
      address account_,
      bool value_
    ) external onlyOwner {
    _setERC721TransferExempt(account_, value_);
  }
}
