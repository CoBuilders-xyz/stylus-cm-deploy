// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";

interface ICacheManager {
    function getMinBid(address program) external view returns (uint192);
    function placeBid(address program) external payable;
    function cacheSize() external view returns (uint64);
    function queueSize() external view returns (uint64);
}

contract CacheManagerAutomation is AutomationCompatibleInterface {
    ICacheManager public cacheManager;
    address public programToBidOn;
    uint256 public minBidAmount;
    
    constructor(address _cacheManager, address _programToBidOn, uint256 _minBidAmount) {
        cacheManager = ICacheManager(_cacheManager);
        programToBidOn = _programToBidOn;
        minBidAmount = _minBidAmount;
    }

    function checkUpkeep(bytes calldata /* checkData */) 
        external view override returns (bool upkeepNeeded, bytes memory /* performData */)
    {
        uint192 requiredBid = cacheManager.getMinBid(programToBidOn);
        uint64 availableSpace = cacheManager.cacheSize() - cacheManager.queueSize();
        upkeepNeeded = (requiredBid <= minBidAmount && availableSpace > 0);
    }

    function performUpkeep(bytes calldata /* performData */) external override {
        uint192 requiredBid = cacheManager.getMinBid(programToBidOn);
        require(requiredBid <= minBidAmount, "Bid too high");
        require(address(this).balance >= requiredBid, "Insufficient balance");
        
        cacheManager.placeBid{value: requiredBid}(programToBidOn);
    }
    
    receive() external payable {} // Allow contract to receive ETH
}