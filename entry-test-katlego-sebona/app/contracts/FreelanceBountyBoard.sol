// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title FreelanceBountyBoard
 * @dev A decentralised marketplace for skills and bounties
 * @notice PART 1 - Freelance Bounty Board (MANDATORY)
 */
contract FreelanceBountyBoard {
    
    // TODO: Define your state variables here

    struct Freelancer {
        string skill;
        bool isRegistered;
    }

    struct Bounty {
        address employer;
        string description;
        string skillRequired;
        uint256 amount;
        bool isCompleted;
        address freelancer;
        string submissionUrl;
    }
    // Consider:
    // - How will you track freelancers and their skills?
    // - How will you store bounty information?
    // - How will you manage payments? 

    mapping(address => Freelancer) public freelancers;
    mapping(uint256 => Bounty) public bounties;
    uint256 public bountyCounter;

    address public owner;
    
    event FreelancerRegistered(address freelancer, string skill);
    event BountyPosted(uint256 bountyId, address employer, string description, string skillRequired, uint256 amount);
    event BountyApplied(uint256 bountyId, address freelancer);
    event WorkSubmitted(uint256 bountyId, address freelancer, string submissionUrl);
    event BountyApproved(uint256 bountyId, address employer, address freelancer, uint256 amount);

    constructor() {
        owner = msg.sender;
    }
    
    // TODO: Implement registerFreelancer function
    // Requirements:
    // - Freelancers should be able to register with their skill
    // - Prevent duplicate registrations
    // - Emit an event when a freelancer registers

    function registerFreelancer(string memory skill) public {
        require(!freelancers[msg.sender].isRegistered, "Freelancer already registered");
        freelancers[msg.sender] = Freelancer(skill, true);
        emit FreelancerRegistered(msg.sender, skill);
    }
    

    // TODO: Implement postBounty function
    // Requirements:
    // - Employers post bounties with bounty (msg.value)
    // - Store bounty description and required skill
    // - Ensure ETH is sent with the transaction
    // - Emit an event when bounty is posted

    function postBounty(string memory description, string memory skillRequired) public payable {
        require (msg.value > 0, "Bounty must have a positive value");
        uint256 bountyId = bounties,Legnth;
        bountyCounter++;
        bounties[bountyCounter] = Bounty({
            employer: msg.sender,
            description: description,
            skillRequired: skillRequired,
            amount: msg.value,
            isCompleted: false,
            freelancer: address(0),
            submissionUrl: ""
        });
        emit BountyPosted(bountyCounter, msg.sender, description, skillRequired, msg.value);
    }
    
    // TODO: Implement applyForBounty function
    // Requirements:
    // - Freelancers can apply for bounties
    // - Check if freelancer has the required skill
    // - Prevent duplicate applications
    // - Emit an event
    function applyForBounty(uint256 bountyId) public {
        require(bountyId > 0 && bountyId <= bountyCounter, "Invalid bounty ID");
        require(freelancers[msg.sender].isRegistered, "Freelancer not registered");
        require(bounties[bountyId].freelancer == address(0), "Already has an applicant");
        keccak256(abi.encodePacked(freelancers[msg.sender].skill)) ==
        keccak256(abi.encodePacked(bounties[bountyId].skillRequired)),
        "Freelancer doesn't have required skill"
        bounties[bountyId].freelancer = msg.sender;
        emit BountyApplied(bountyId, msg.sender);
    }
    
    // TODO: Implement submitWork function
    // Requirements:
    // - Freelancers submit completed work (with proof/URL)
    // - Validate that freelancer applied for this bounty
    // - Update bounty status
    // - Emit an event
    function submitWork(uint256 bountyId, string memory submissionUrl) public {
        require(bountyId > 0 && bountyId <= bountyCounter, "Invalid bounty ID");
        require(bounties[bountyId].freelancer == msg.sender, "Not the applicant for this bounty");
        require(bounties[bountyId].isCompleted == false, "Bounty already completed");
        bounties[bountyId].submissionUrl = submissionUrl;
        emit WorkSubmitted(bountyId, msg.sender, submissionUrl);
    }
    
    // TODO: Implement approveAndPay function
    // Requirements:
    // - Only employer who posted bounty can approve
    // - Transfer payment to freelancer
    // - CRITICAL: Implement reentrancy protection
    // - Update bounty status to completed
    // - Emit an event
    function approveAndPay(uint256 bountyId, address freelancer) public {
        require(bountyId > 0 && bountyId <= bountyCounter, "Invalid bounty ID");
        require(msg.sender == bounties[bountyId].employer, "Only employer can approve");
        require(bounties[bountyId].freelancer == freelancer, "Not the applicant for this bounty");
        require(bounties[bountyId].isCompleted == false, "Bounty already completed");
        require(address(this).balance >= bounties[bountyId].amount, "Insufficient funds");

        // Checks done, now effects
        bounties[bountyId].isCompleted = true;

        // Interactions last
        payable(freelancer).transfer(bounties[bountyId].amount);

        emit BountyApproved(bountyId, freelancer, bounties[bountyId].amount);
    }
    
    // BONUS: Implement dispute resolution
    // What happens if employer doesn't approve but work is done?
    // Consider implementing a timeout mechanism
    
    // Helper functions you might need:
    // - Function to get bounty details
    // - Function to check freelancer registration
    // - Function to get all bounties
}