// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function decimals() external view returns (uint256);
}

contract TokenClaim {
    enum Claim {
        notClaimed,
        claimed
    }
    //Claim public claim;

    mapping(address => Claim) public isClaimed;

    address public immutable token;
    uint256 constant allowedAmount = 100;

    constructor() {
        token = 0xc094417B62E4BF85e575a2B5be955F1f55403a6D;
    }

    function getAllowedAmount() internal view returns (uint256) {
        uint256 decimals = IERC20(token).decimals();
        return allowedAmount * (10 ** decimals);
    }

    function getContractBalance() public view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    function claim() public {
        require(
            getContractBalance() >= getAllowedAmount(),
            "Claim:: Sorry No tokens available for claiming"
        );
        require(
            isClaimed[msg.sender] == Claim.notClaimed,
            "Claim:: You are already claimed the token"
        );
        isClaimed[msg.sender] = Claim.claimed;
        IERC20(token).transfer(msg.sender, getAllowedAmount());
    }
}
