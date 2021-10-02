// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.6.12;

import "./GenericMerkleDistributor.sol";
import "@openzeppelin/contracts3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts3/access/Ownable.sol";
import "@openzeppelin/contracts3/utils/Strings.sol";

contract ERC721MerkleDistributor is GenericMerkleDistributor, ERC721, Ownable {
  using Strings for uint256;

  uint8 public tokenURIVariability;
  string private _baseTokenURI;

  constructor(
    bytes32 merkleRoot_,
    uint8 _tokenURIVariability,
    string memory _name,
    string memory _symbol
  )
  ERC721(_name, _symbol)
  GenericMerkleDistributor(merkleRoot_)
  public
  {
    tokenURIVariability = _tokenURIVariability;
  }

  function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) claimHelper(index, account, amount, merkleProof) external {
    uint256 supply = totalSupply();
    for(uint256 i; i < amount; i++){
        _safeMint(msg.sender, supply + i);
    }
  }

  function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
    _setMerkleRoot(merkleRoot_);
  }

  function setBaseURI(string memory baseURI) public onlyOwner {
      _baseTokenURI = baseURI;
  }

  function setTokenURIVariability(uint8 boolean) external onlyOwner {
    tokenURIVariability = boolean; // 1 or 0
  }

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

    if (tokenURIVariability == 0) {
      // static token uri, i.e. 1 image only
      return _baseTokenURI;
    } else {
      string memory json = ".json";
      return bytes(_baseTokenURI).length > 0
          ? string(abi.encodePacked(_baseTokenURI, tokenId.toString(), json))
          : '';
    }
  }
}
