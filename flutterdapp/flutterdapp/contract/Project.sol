pragma solidity ^0.8.20;

contract Project {
    string public latitude = "0.00";
    string public longitude = "0.00";

    function sendCoordinates(string memory _latitude, string memory _longitude) public {
        latitude = _latitude;
        longitude = _longitude;
    }

    function sendMoney(address _receiver, uint _amount) public {
        if (_amount > balances[msg.sender]) {
            revert("Insufficient balance");
        }
    }

    function readCoordinates() public view returns (string memory, string memory) {
        return (latitude, longitude);
    }
}
