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

    mapping(uint256 => uint256) private pauseEvolutionTime;
    mapping(uint256 => uint256) private continueEvolution;
    mapping(uint256 => uint256) private pauseEvolutionTime1;

    event EvolutionPaused(uint256 id_, uint256 timestamp);
    event EvolutionContinued(uint256 id_, uint256 timestamp);

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
        uint256 timePause;

        if (pauseEvolutionTime[id_] == 0) {
            timePause = block.timestamp - lastTransferTimestamp;
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] == 0) {
            timePause = pauseEvolutionTime[id_] - lastTransferTimestamp;
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] > 0) {
            timePause = (block.timestamp - continueEvolution[id_]) + (pauseEvolutionTime[id_] - lastTransferTimestamp);
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] > 0 && continueEvolution[id_] < pauseEvolutionTime[id_]) {
            timePause = (pauseEvolutionTime[id_] - continueEvolution[id_]) + (pauseEvolutionTime1[id_] - lastTransferTimestamp);
        }

        if (timePause >= 7 days) {
            return evo2Path2;
        } else {
            return evo2Path1;
        }
    }

    function getEvo3Path(uint256 lastTransferTimestamp, uint256 id_) internal view returns (string memory) {
        uint256 timePause;

        if (pauseEvolutionTime[id_] == 0) {
            timePause = block.timestamp - lastTransferTimestamp;
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] == 0) {
            timePause = pauseEvolutionTime[id_] - lastTransferTimestamp;
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] > 0) {
            timePause = (block.timestamp - continueEvolution[id_]) + (pauseEvolutionTime[id_] - lastTransferTimestamp);
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] > 0 && continueEvolution[id_] < pauseEvolutionTime[id_]) {
            timePause = (pauseEvolutionTime[id_] - continueEvolution[id_]) + (pauseEvolutionTime1[id_] - lastTransferTimestamp);
        }

        if (timePause >= 14 days) {
            return evo3Path3;
        } else if (timePause >= 7 days) {
            return evo3Path2;
        } else {
            return evo3Path1;
        }
    }

    function getEvo4Path(uint256 lastTransferTimestamp, uint256 id_) internal view returns (string memory) {
        uint256 timePause;

        if (pauseEvolutionTime[id_] == 0) {
            timePause = block.timestamp - lastTransferTimestamp;
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] == 0) {
            timePause = pauseEvolutionTime[id_] - lastTransferTimestamp;
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] > 0) {
            timePause = (block.timestamp - continueEvolution[id_]) + (pauseEvolutionTime[id_] - lastTransferTimestamp);
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] > 0 && continueEvolution[id_] < pauseEvolutionTime[id_]) {
            timePause = (pauseEvolutionTime[id_] - continueEvolution[id_]) + (pauseEvolutionTime1[id_] - lastTransferTimestamp);
        }

        if (timePause >= 21 days) {
            return evo4Path4;
        } else if (timePause >= 14 days) {
            return evo4Path3;
        } else if (timePause >= 7 days) {
            return evo4Path2;
        } else {
            return evo4Path1;
        }
    }

    function getEvo5Path(uint256 lastTransferTimestamp, uint256 id_) internal view returns (string memory) {
        uint256 timePause;

        if (pauseEvolutionTime[id_] == 0) {
            timePause = block.timestamp - lastTransferTimestamp;
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] == 0) {
            timePause = pauseEvolutionTime[id_] - lastTransferTimestamp;
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] > 0) {
            timePause = (block.timestamp - continueEvolution[id_]) + (pauseEvolutionTime[id_] - lastTransferTimestamp);
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] > 0 && continueEvolution[id_] < pauseEvolutionTime[id_]) {
            timePause = (pauseEvolutionTime[id_] - continueEvolution[id_]) + (pauseEvolutionTime1[id_] - lastTransferTimestamp);
        }

        if (timePause >= 28 days) {
            return evo5Path5;
        } else if (timePause >= 21 days) {
            return evo5Path4;
        } else if (timePause >= 14 days) {
            return evo5Path3;
        } else if (timePause >= 7 days) {
            return evo5Path2;
        } else {
            return evo5Path1;
        }
    }

    function getEvo9Path(uint256 lastTransferTimestamp, uint256 id_) internal view returns (string memory) {
        uint256 timePause;

        if (pauseEvolutionTime[id_] == 0) {
            timePause = block.timestamp - lastTransferTimestamp;
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] == 0) {
            timePause = pauseEvolutionTime[id_] - lastTransferTimestamp;
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] > 0) {
            timePause = (block.timestamp - continueEvolution[id_]) + (pauseEvolutionTime[id_] - lastTransferTimestamp);
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] > 0 && continueEvolution[id_] < pauseEvolutionTime[id_]) {
            timePause = (pauseEvolutionTime[id_] - continueEvolution[id_]) + (pauseEvolutionTime1[id_] - lastTransferTimestamp);
        }

        if (timePause >= 56 days) {
            return evo9Path9;
        } else if (timePause >= 49 days) {
            return evo9Path8;
        } else if (timePause >= 42 days) {
            return evo9Path7;
        } else if (timePause >= 35 days) {
            return evo9Path6;
        } else if (timePause >= 28 days) {
            return evo9Path5;
        } else if (timePause >= 21 days) {
            return evo9Path4;
        } else if (timePause >= 14 days) {
            return evo9Path3;
        } else if (timePause >= 7 days) {
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

    /**
    * @dev Function to pause evolution for a specific token.
    * @param id_ The ID of the token to pause evolution for.
    * Requirements:
    * - The caller must be the owner of the token.
    * - Evolution must not already be paused for the token.
    */

    function _getPauseEvolutionTime(uint256 id_) internal view returns (uint256) {
        return pauseEvolutionTime[id_];
    }

    function setPauseEvolution(uint256 id_) external {
        require(ownerOf(id_) == _msgSender(), "Pokemoon: caller is not the owner of the token");

        if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] == 0) {
            pauseEvolutionTime[id_] = block.timestamp;
            pauseEvolutionTime[id_] = pauseEvolutionTime1[id_];
            emit EvolutionPaused(id_, block.timestamp);
        } else if (pauseEvolutionTime[id_] > 0 && continueEvolution[id_] > 0) {
            pauseEvolutionTime[id_] = block.timestamp;
            emit EvolutionPaused(id_, block.timestamp);
            
        }
    }

    /**
    * @dev Function to resume evolution for a specific token.
    * @param id_ The ID of the token to resume evolution for.
    * Requirements:
    * - The caller must be the owner of the token.
    * - Evolution must be paused for the token.
    */

    function _getContinueEvolutionTime(uint256 id_) internal view returns (uint256) {
        return continueEvolution[id_];
    }

    function setContinueEvolution(uint256 id_) external {
        require(ownerOf(id_) == _msgSender(), "Pokemoon: caller is not the owner of the token");

        continueEvolution[id_] = block.timestamp;

        emit EvolutionContinued(id_, block.timestamp);
    }

    /**
    * @dev Function to check if evolution is paused for a specific token.
    * @param id_ The ID of the token to check.
    * @return A boolean indicating whether evolution is paused for the token.
    */
    function isEvolutionPaused(uint256 id_) external view returns (bool) {
        return pauseEvolutionTime[id_] > 0;
    }

        function getTimeUntilNextEvolution(uint256 id_) external view returns (uint256) {
        require(ownerOf(id_) == _msgSender(), "Pokemoon: caller is not the owner of the token");

        uint256 lastTransferTimestamp = _getERC721LastTransferTimestamp(id_);
        uint256 pauseTime = _getPauseEvolutionTime(id_);
        uint256 continueTime = _getContinueEvolutionTime(id_);
        uint256 evolutionInterval = 7 days;

        uint256 timeRemaining;

        if (pauseTime > 0 && continueTime == 0) {
            return 1;  // Special code indicating pause
        } else if (pauseTime > 0 && continueTime > 0) {
            // Remaining time taking into account pause and unpause
            uint256 timeSincePause = (block.timestamp - continueEvolution[id_]) + (pauseEvolutionTime[id_] - lastTransferTimestamp);
            uint256 timeSincePauseInInterval = timeSincePause % evolutionInterval;
            timeRemaining = (evolutionInterval - timeSincePauseInInterval) / 1 days;
        } else {
            // Remaining time without pause
            uint256 timeSinceLastTransfer = block.timestamp - lastTransferTimestamp;
            timeRemaining = (evolutionInterval - (timeSinceLastTransfer % evolutionInterval)) / 1 days;
        }

        return timeRemaining;
    }
}
