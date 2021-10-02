// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.6.12;

import "@openzeppelin/contracts3/access/Ownable.sol";
import "@openzeppelin/contracts3/token/ERC20/IERC20.sol";

// Allow owner to claw back tokens deployed to redistribute or burn
contract TimedClawback is Ownable {
  address public immutable token;
  uint256 public immutable durationDays;
  uint256 public immutable startTime;

  constructor(address _token, uint256 _durationDays) public {
    // implicit: require address of token != address(0)
    token = _token;
    durationDays = _durationDays * 1 days;
    startTime = block.timestamp;
  }

  function clawBack() external onlyOwner {
    require((startTime + durationDays) < block.timestamp, "Too early");
    IERC20 erc20 = IERC20(token);
    require(erc20.transfer(owner(), erc20.balanceOf(address(this))), "Clawback failed");
  }
}
