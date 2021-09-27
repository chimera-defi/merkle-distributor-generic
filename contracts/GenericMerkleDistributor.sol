// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.6.12;

import "@openzeppelin/contracts/cryptography/MerkleProof.sol";
import "./interfaces/IGenericMerkleDistributor.sol";

contract GenericMerkleDistributor is IGenericMerkleDistributor {
    bytes32 public override merkleRoot;

    // This is a packed array of booleans.
    mapping(uint256 => uint256) private claimedBitMap;

    constructor(bytes32 merkleRoot_) public {
        merkleRoot = merkleRoot_;
    }

    function isClaimed(uint256 index) public view override returns (bool) {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        uint256 claimedWord = claimedBitMap[claimedWordIndex];
        uint256 mask = (1 << claimedBitIndex);
        return claimedWord & mask == mask;
    }

    function _setClaimed(uint256 index) private {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
    }

    // The claim in the generic contract here needs to be used in a inheriting contract that implements 
    // The actual action of claiming a token or nft 
    function _claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) internal {
        require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');

        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(index, account, amount));
        require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');

        // Mark it claimed and send the token.
        _setClaimed(index);

        emit Claimed(index, account, amount);
    }

    modifier claimHelper(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) {
        _claim(index, account, amount, merkleProof);
        _;
        emit Claimed(index, account, amount);
    }

    // Useful for updating the merkle root to reuse the contract for further airdrops
    function _setMerkleRoot(bytes32 merkleRoot_) internal {
        merkleRoot = merkleRoot_;
    }
}
