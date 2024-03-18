// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC404} from "./ERC404.sol";

contract Test is Ownable, ERC404 {

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
                folderPath = getEvo2Path(lastTransferTimestamp, id_);
                jsonFileName = string.concat(Strings.toString((id_ % 213) + 1), ".json");
            } else if (seed <= 210) {
                folderPath = getEvo3Path(lastTransferTimestamp, id_);
                jsonFileName = string.concat(Strings.toString((id_ % 117) + 1), ".json");
            } else if (seed <= 235) {
                folderPath = getEvo4Path(lastTransferTimestamp, id_);
                jsonFileName = string.concat(Strings.toString((id_ % 5) + 1), ".json");
            } else if (seed <= 250) {
                folderPath = getEvo5Path(lastTransferTimestamp, id_);
                jsonFileName = string.concat(Strings.toString((id_ % 2) + 1), ".json");
            } else if (seed <= 255) {
                folderPath = getEvo9Path(lastTransferTimestamp, id_);
                jsonFileName = "1.json";
            }

            string memory fullURI = string.concat(dataURI, folderPath, jsonFileName);

            return fullURI;
        }
    }

    function getEvo2Path(uint256 lastTransferTimestamp, uint256 id_) internal view returns (string memory) {

        uint256 evolutionTime = block.timestamp - lastTransferTimestamp - getTimeSpentOnPause(id_);

        if (evolutionTime >= 7 minutes) {
            return evo2Path2;
        } else {
            return evo2Path1;
        }
    }

    function getEvo3Path(uint256 lastTransferTimestamp, uint256 id_) internal view returns (string memory) {

        uint256 evolutionTime = block.timestamp - lastTransferTimestamp - getTimeSpentOnPause(id_);

        if (evolutionTime >= 14 minutes) {
            return evo3Path3;
        } else if (evolutionTime >= 7 minutes) {
            return evo3Path2;
        } else {
            return evo3Path1;
        }
    }

    function getEvo4Path(uint256 lastTransferTimestamp, uint256 id_) internal view returns (string memory) {

        uint256 evolutionTime = block.timestamp - lastTransferTimestamp - getTimeSpentOnPause(id_);


        if (evolutionTime >= 21 minutes) {
            return evo4Path4;
        } else if (evolutionTime >= 14 minutes) {
            return evo4Path3;
        } else if (evolutionTime >= 7 minutes) {
            return evo4Path2;
        } else {
            return evo4Path1;
        }
    }

    function getEvo5Path(uint256 lastTransferTimestamp, uint256 id_) internal view returns (string memory) {

        uint256 evolutionTime = block.timestamp - lastTransferTimestamp - getTimeSpentOnPause(id_);

        if (evolutionTime >= 28 minutes) {
            return evo5Path5;
        } else if (evolutionTime >= 21 minutes) {
            return evo5Path4;
        } else if (evolutionTime >= 14 minutes) {
            return evo5Path3;
        } else if (evolutionTime >= 7 minutes) {
            return evo5Path2;
        } else {
            return evo5Path1;
        }
    }

    function getEvo9Path(uint256 lastTransferTimestamp, uint256 id_) internal view returns (string memory) {

        uint256 evolutionTime = block.timestamp - lastTransferTimestamp - getTimeSpentOnPause(id_);

        if (evolutionTime >= 56 minutes) {
            return evo9Path9;
        } else if (evolutionTime >= 49 minutes) {
            return evo9Path8;
        } else if (evolutionTime >= 42 minutes) {
            return evo9Path7;
        } else if (evolutionTime >= 35 minutes) {
            return evo9Path6;
        } else if (evolutionTime >= 28 minutes) {
            return evo9Path5;
        } else if (evolutionTime >= 21 minutes) {
            return evo9Path4;
        } else if (evolutionTime >= 14 minutes) {
            return evo9Path3;
        } else if (evolutionTime >= 7 minutes) {
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

    function getTimeUntilNextEvolution(uint256 id_) external view returns (uint256) {

        uint256 lastTransferTimestamp = _getERC721LastTransferTimestamp(id_);
        uint256 evolutionTime = block.timestamp - lastTransferTimestamp - getTimeSpentOnPause(id_);
        uint256 evolutionInterval = 7 minutes;

        if (getPauseEvolutionTime(id_) > 0) {
            return 11; // Special code indicating pause
        }

        if (containsSubstring(tokenURI(id_), evo1Path)) {
            return 13; // Special code indicating Not Evo
        }
        if (containsSubstring(tokenURI(id_), evo2Path2)) {
            return 12; // Special code indicating evo2Path2
        }
        if (containsSubstring(tokenURI(id_), evo3Path3)) {
            return 12; // Special code indicating evo3Path3
        }
        if (containsSubstring(tokenURI(id_), evo4Path4)) {
            return 12; // Special code indicating evo4Path4
        }
        if (containsSubstring(tokenURI(id_), evo5Path5)) {
            return 12; // Special code indicating evo5Path5
        }
        if (containsSubstring(tokenURI(id_), evo9Path9)) {
            return 12; // Special code indicating evo9Path9
        }
    uint256 timeRemaining = (evolutionInterval - (evolutionTime) % evolutionInterval) / 1 minutes;
    return timeRemaining;
    }
}
