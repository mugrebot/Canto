// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

error ZeroAddress();
error ZeroValue();
error NotContract();
error NoBalance();
error WithdrawalFailed();

interface ITurnstile {
    function register(address) external returns(uint256);
    function getTokenId(address _smartContract) external view returns (uint256);
    function balances(uint256 _tokenId) external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
    function withdraw(uint256 _tokenId, address payable _recipient, uint256 _amount) external returns (uint256);
}

contract MyContract {
    event PayContract(address indexed sender, uint256 value);

    ITurnstile public immutable turnstile;

    mapping (address => uint256) balancio;
    
    constructor(address _turnstile) {
        if (_turnstile == address(0)) {
            revert ZeroAddress();
        }
        turnstile = ITurnstile(_turnstile);
        turnstile.register(address(this));
    }

    function getCsrAddress() external view returns (address) {
        return address(turnstile);
    }

    receive() external payable {
        if (msg.value == 0) {
            revert ZeroValue();
        }
        emit PayContract(msg.sender, msg.value);
    }

    function myFunction(address _contractAddress) external view returns (uint256) {
        if (_contractAddress == address(0)) {
            revert ZeroAddress();
        }
        //check if address is a contract
        uint256 size;
        assembly { size := extcodesize(_contractAddress) }
        if (size == 0) {
            revert NotContract();
        }
        uint256 tokenId = turnstile.getTokenId(_contractAddress);
        uint256 balance = turnstile.balances(tokenId);
        return balance;
    }

    function viewTurnstile() external view returns (uint256, uint256, address) {
uint256 tokenId = turnstile.getTokenId(address(this));
uint256 balance = turnstile.balances(tokenId);
address theContract = address(this);

return (tokenId, balance, theContract);
    }

function viewBalancio () public view returns (uint256) {
    return balancio[msg.sender];
}


function withdrawtoUser(address payable _user) external {

uint256 tokenId = turnstile.getTokenId(address(this));
uint256 balance = turnstile.balances(tokenId);



balancio[msg.sender] += turnstile.withdraw(tokenId, payable(address(this)), balance);

if (balancio[msg.sender] == 0) {
    revert NoBalance();
    }
if (balancio[msg.sender] > 0) {
    _user.transfer(balancio[msg.sender]);
    balancio[msg.sender] = 0;
    }
}

}

