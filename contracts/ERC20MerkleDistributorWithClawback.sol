// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.6.12;

import "./GenericMerkleDistributor.sol";
import "./TimedClawback.sol";

contract ERC20MerkleDistributorWithClawback is GenericMerkleDistributor, TimedClawback {
  constructor(
    address token_,
    bytes32 merkleRoot_,
    uint256 durationDays_
  )
  GenericMerkleDistributor(merkleRoot_)
  TimedClawback(token_, durationDays_)
  public
  {}

  function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) claimHelper(index, account, amount, merkleProof) external {
    require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
  }

  function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
    _setMerkleRoot(merkleRoot_);
  }
}
