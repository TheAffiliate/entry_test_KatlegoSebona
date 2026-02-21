#Part A: MCQ Answers:

Question 1 = B, simply becuase the program must "Allow providers to list solar energy credits as NFTs with generation certificates", and "Enable buyers to swap tokens for energy credits using a DEX"

Question 2 = D

ERC-721 cost = 40 * 100,000 gas = 4,000,000 gas ERC-721 cost in ETH = 4,000,000 gas * 20 gwei = 0.08 ETH ERC-721 cost in USD = 0.08 ETH * $3,000 = $240

ERC-1155 cost = 150,000 gas + (40 - 1) * 5,000 gas = 150,000 + 190,000 = 340,000 gas ERC-1155 cost in ETH = 340,000 gas * 20 gwei = 0.0068 ETH ERC-1155 cost in USD = 0.0068 ETH * $3,000 = $20.4

Difference = $240 - $20.4 = $219.6 ≈ $180

Question 3 = B

# PART 2

B

=======================================================================

#Part B: Design Document:

1. Data Structure Choices
   
#Mapping vs. Array:

Mapping: Used when you need to access data by a unique key (e.g., address to uint for balances). Mappings are more gas-efficient for lookups and updates.
Array: Used when you need to maintain order or iterate over all elements (e.g., bounties in FreelanceBountyBoard). Arrays are more gas-efficient for iterating but less efficient for individual access.

#State Variables Structure:

FreelanceBountyBoard: Used an array (bounties) to maintain order and allow iteration. Used mappings (bountyToApplicants) for efficient applicant tracking.
DecentralisedRaffle: Used an array (entrants) to maintain order and allow iteration. Used a mapping (entrantsMap) for efficient entry tracking.

#Trade-offs for Storage Efficiency:

Mappings: More gas-efficient for individual access but less efficient for iteration.
Arrays: More gas-efficient for iteration but less efficient for individual access. Chose based on the primary use case (e.g., iteration vs. lookup).

2. Security Measures

#Reentrancy Attacks:

Implemented the Checks-Effects-Interactions pattern to prevent reentrancy. For example, in FreelanceBountyBoard, the selectWinner function updates state before transferring funds.
Access Control Vulnerabilities:

Used onlyOwner modifier to restrict sensitive functions (e.g., postBounty, selectWinner) to the contract owner.

#Integer Overflow/Underflow:

Used Solidity ^0.8.19, which has built-in checks for overflow/underflow. No additional safeguards needed. Can also be used for future iteration of solidity should an update be released and i want to transform the program into an upgradeable contract.

#Front-running/Randomness Manipulation (DecentralisedRaffle):

Used block.timestamp for randomness, which is not perfect but mitigates some manipulation risks. For better security, consider using a more robust randomness solution like Chainlink VRF.

3. Trade-offs & Future Improvements

#Gas Optimization Opportunities:

Use uint256 instead of uint for consistency and future-proofing.
Consider using mapping for bounties in FreelanceBountyBoard if order is not critical.

#Additional Features:

Dispute Resolution: Implement a dispute mechanism for bounties.
Multiple Prize Tiers: Allow multiple winners with different prize amounts.

#Better Error Handling:

Add more detailed error messages (e.g., require messages) to help users understand failures.
REAL-WORLD DEPLOYMENT CONCERNS

1. Gas Costs

#Estimated Gas for Key Functions:

postBounty: ~100,000 gas (depends on data size).
selectWinner: ~150,000 gas (depends on number of applicants).

#Viability in Constrained Environments:

High gas fees could make these contracts expensive for users. Consider layer-2 solutions (e.g., Optimism, Arbitrum) to reduce costs.

#Optimization Strategies:

Used mapping for efficient lookups.
Minimized storage writes in loops.

2. Scalability

#Performance Considerations:

Loops/Arrays: Large arrays (e.g., 10,000+ entries) can be gas-intensive. Consider pagination or off-chain solutions.
Storage Cost: Large mappings/arrays increase storage costs. Consider using more efficient data structures or off-chain storage.

#Potential Bottlenecks:

selectWinner: Iterating over all entrants can be gas-intensive. Consider using a more efficient selection mechanism.
applyForBounty: Adding many applicants can be gas-intensive. Consider batching or off-chain solutions.

3. User Experience

#Onboarding Process:

Simplify the onboarding process with clear instructions and tutorials.
Provide a user-friendly interface for interacting with the contracts.

#MetaMask Alternatives:

Consider using wallet alternatives like WalletConnect or Coinbase Wallet for broader accessibility.

#Mobile Accessibility:

To ensure the interface is mobile-friendly and responsive. Provide a dedicated mobile app if necessary.
