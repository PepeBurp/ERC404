// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC404} from "./ERC404.sol";

contract Pokemoon is Ownable, ERC404 {

    string public dataURI;
    string public baseTokenURI;

    string private constant evo1Path = "evo1/";
    string private constant evo2Path1 = "evo2/1/";
    string private constant evo2Path2 = "evo2/2/";
    string private constant evo3Path1 = "evo3/1/";
    string private constant evo3Path2 = "evo3/2/";
    string private constant evo3Path3 = "evo3/3/";
    string private constant evo4Path1 = "evo4/1/";
    string private constant evo4Path2 = "evo4/2/";
    string private constant evo4Path3 = "evo4/3/";
    string private constant evo4Path4 = "evo4/4/";
    string private constant evo5Path1 = "evo5/1/";
    string private constant evo5Path2 = "evo5/2/";
    string private constant evo5Path3 = "evo5/3/";
    string private constant evo5Path4 = "evo5/4/";
    string private constant evo5Path5 = "evo5/5/";
    string private constant evo9Path1 = "evo9/1/";
    string private constant evo9Path2 = "evo9/2/";
    string private constant evo9Path3 = "evo9/3/";
    string private constant evo9Path4 = "evo9/4/";
    string private constant evo9Path5 = "evo9/5/";
    string private constant evo9Path6 = "evo9/6/";
    string private constant evo9Path7 = "evo9/7/";
    string private constant evo9Path8 = "evo9/8/";
    string private constant evo9Path9 = "evo9/9/";

    // Mapping для хранения времени паузы эволюции для каждого токена
    mapping(uint256 => uint256) private pausedTimes; 

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 maxTotalSupplyERC721_,
        address initialOwner_,
        address initialMintRecipient_
    )
        ERC404(name_, symbol_, decimals_) Ownable(initialOwner_)
    {
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

            if (seed <= 100) {
                folderPath = evo1Path;
                jsonFileName = string.concat(Strings.toString((id_ % 203) + 1), ".json");
            } else if (seed <= 160) {
                folderPath = getEvo2Path(lastTransferTimestamp);
                jsonFileName = string.concat(Strings.toString((id_ % 213) + 1), ".json");
            } else if (seed <= 210) {
                folderPath = getEvo3Path(lastTransferTimestamp);
                jsonFileName = string.concat(Strings.toString((id_ % 117) + 1), ".json");
            } else if (seed <= 235) {
                folderPath = getEvo4Path(lastTransferTimestamp);
                jsonFileName = string.concat(Strings.toString((id_ % 5) + 1), ".json");
            } else if (seed <= 250) {
                folderPath = getEvo5Path(lastTransferTimestamp);
                jsonFileName = string.concat(Strings.toString((id_ % 2) + 1), ".json");
            } else if (seed <= 255) {
                folderPath = getEvo9Path(lastTransferTimestamp);
                jsonFileName = "1.json";
            }

            string memory fullURI = string.concat(dataURI, folderPath, jsonFileName);

            return fullURI;
        }
    }

    function getEvo2Path(uint256 lastTransferTimestamp) internal view returns (string memory) {
        if (lastTransferTimestamp == 0 || bytes(evo2Path2).length == 0) {
            return evo2Path1;
        } else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 7 days) {
            return evo2Path2;
        } else {
            return evo2Path1;
        }
    }

    function getEvo3Path(uint256 lastTransferTimestamp) internal view returns (string memory) {
        if (lastTransferTimestamp == 0 || bytes(evo3Path3).length == 0) {
            return evo3Path1;
        } else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 14 days) {
            return evo3Path3;
        } else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 7 days) {
            return evo3Path2;
        } else {
            return evo3Path1;
        }
    }

    function getEvo4Path(uint256 lastTransferTimestamp) internal view returns (string memory) {
        if (lastTransferTimestamp == 0 || bytes(evo4Path4).length == 0) {
            return evo4Path1;
        } else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 21 days) {
            return evo4Path4;
        } else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 14 days) {
            return evo4Path3;
        } else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 7 days) {
            return evo4Path2;
        } else {
            return evo4Path1;
        }
    }

    function getEvo5Path(uint256 lastTransferTimestamp) internal view returns (string memory) {
        if (lastTransferTimestamp == 0 || bytes(evo5Path5).length == 0) {
            return evo5Path1;
        } else {
            // Учитываем время, прошедшее с момента установки паузы
            uint256 elapsedTime = block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp];

            if (elapsedTime >= 28 days) {
                return evo5Path5;
            } else if (elapsedTime >= 21 days) {
                return evo5Path4;
            } else if (elapsedTime >= 14 days) {
                return evo5Path3;
            } else if (elapsedTime >= 7 days) {
                return evo5Path2;
            } else {
                return evo5Path1;
            }
        }
    }

    function getEvo9Path(uint256 lastTransferTimestamp) internal view returns (string memory) {
        if (lastTransferTimestamp == 0 || bytes(evo9Path9).length == 0) {
            return evo9Path1;
        } else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 56 days) {
            return evo9Path9;
        }  else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 49 days) {
            return evo9Path8;
        }  else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 42 days) {
            return evo9Path7;
        }  else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 35 days) {
            return evo9Path6;
        } else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 28 days) {
            return evo9Path5;
        } else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 21 days) {
            return evo9Path4;
        } else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 14 days) {
            return evo9Path3;
        } else if (block.timestamp - lastTransferTimestamp - pausedTimes[lastTransferTimestamp] >= 7 days) {
            return evo9Path2;
        } else {
            return evo9Path1;
        }
    }

    function setERC721TransferExempt(address account_, bool value_) external onlyOwner {
        _setERC721TransferExempt(account_, value_);
    }

    // Function for replacing the customRatio value, which determines the ratio of transmitted ERC20/ERC721
    function setCustomRatio(uint256 newRatio) external onlyOwner {
        customRatio = newRatio;
    }

    // Function to pause evolution for a specific token
    function pauseEvolution(uint256 id_) external {
        require(ownerOf(id_) == _msgSender(), "Pokemoon: caller is not the owner of the token");
        require(pausedTimes[id_] == 0, "Pokemoon: evolution is already paused");

        pausedTimes[id_] = block.timestamp - _getERC721LastTransferTimestamp(id_);
    }

    // Function to resume evolution for a specific token
    function continueEvolution(uint256 id_) external {
        require(ownerOf(id_) == _msgSender(), "Pokemoon: caller is not the owner of the token");
        require(pausedTimes[id_] > 0, "Pokemoon: evolution is not paused");

        // Update the last transfer timestamp to account for the time paused
        _updateERC721LastTransferTimestamp(id_);
        // Reset the paused time
        pausedTimes[id_] = 0;
    }

    // Function to check if evolution is paused for a specific token
    function isEvolutionPaused(uint256 id_) external view returns (bool) {
        return pausedTimes[id_] > 0;
    }
}
