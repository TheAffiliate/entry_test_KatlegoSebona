// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title DecentralisedRaffle
 * @dev An advanced raffle smart contract with security features
 * @notice PART 2 - Decentralised Raffle (MANDATORY)
 */
contract DecentralisedRaffle {
    
    address public owner;
    uint256 public raffleId;
    uint256 public raffleStartTime;
    bool public isPaused;
    
    // TODO: Define additional state variables
    // Consider:
    // - How will you track entries?
    // - How will you store player information?
    // - What data structure for managing the pot?
    mapping(address => uint256) public playerEntries;
    uint256 public totalEntries;
    uint256 public uniquePlayers;
    uint256 public constant MIN_ENTRY_AMOUNT = 0.01 ether;
    uint256 public constant MIN_PLAYERS = 3;
    uint256 public constant RAFFLE_DURATION = 1 days;
    uint256 public constant RAFFLE_FEE_PERCENTAGE = 10; // 10% fee

    event RaffleEntry(address indexed player, uint256 entryNumber);

    bool private _reentrancyGuard;
    
    constructor() {
        owner = msg.sender;
        raffleId = 1;
        raffleStartTime = block.timestamp;
        isPaused = false;
    }
    
    // TODO: Implement entry function
    // Requirements:
    // - Players pay minimum 0.01 ETH to enter
    // - Track each entry (not just unique addresses)
    // - Allow multiple entries per player
    // - Emit event with player address and entry count
    function enterRaffle() public payable whenNotPaused {
        require(msg.value >= MIN_ENTRY_AMOUNT, "Minimum entry amount is 0.01 ETH");
        require(block.timestamp >= raffleStartTime, "Raffle not started yet");

        playerEntries[msg.sender] += 1;
        totalEntries += 1;

        // Track unique players
        if (playerEntries[msg.sender] == 1) {
            uniquePlayers++;
        }
        emit RaffleEntry(msg.sender, playerEntries[msg.sender]);
    }
    
    // TODO: Implement winner selection function
    // Requirements:
    // - Only owner can trigger
    // - Select winner from TOTAL entries (not unique players)
    // - Winner gets 90% of pot, owner gets 10% fee
    // - Use a secure random mechanism (better than block.timestamp)
    // - Require at least 3 unique players
    // - Require raffle has been active for 24 hours
    function selectWinner() public {
        // Your implementation here
        // CHALLENGE: How do you generate randomness securely?
        // Consider: blockhash, block.difficulty, etc.
    }
    
    // TODO: Implement circuit breaker (pause/unpause)
    // Requirements:
    // - Owner can pause raffle in emergency
    // - Owner can unpause raffle
    // - When paused, no entries allowed
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }
    
    modifier whenNotPaused() {
        require(!isPaused, "Contract is paused");
        _;
    }
    
    function pause() public onlyOwner {
        // Your implementation
    }
    
    function unpause() public onlyOwner {
        // Your implementation
    }
    
    // TODO: Implement reentrancy protection
    // CRITICAL: Prevent reentrancy attacks when sending ETH
    // Use checks-effects-interactions pattern
    
    // TODO: Helper/View functions
    // - Get current pot balance
    // - Get player entry count
    // - Check if raffle is active
    // - Get unique player count
    
    // BONUS: Add multiple prize tiers (1st, 2nd, 3rd place)
    // BONUS: Add refund mechanism if minimum players not reached
}