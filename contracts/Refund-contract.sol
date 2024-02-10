// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ECR20.sol";

contract GeoLogixRefund {
    address public owner;
    YourERC20Token public token;
    
    strut Driver {
        string name;
        uint256 latitude;
        uint256 longitude;
        uint256 allowedDistance;
        uint256 requiredTime;
        uint256 timeTolerance;
        uint256 refundAmount;
        uint256 rating;
        uint256 tokens;
        bool isRegistered;
        bool isInCompliance;
    }
    
    mapping(address => Driver) public drivers;
    address[] public driverAddresses;
    
    event DriverRegistered(address driverAddress);
    event CoordinateIngested(address driverAddress, uint256 latitude, uint256 longitude, uint256 timestamp);
    event ComplianceStatusChanged(address driverAddress, bool isInCompliance);

    constructor(address initialAddress) {
        owner = msg.sender;
        token = new YourERC20Token(initialAddress);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function registerDriver(address driverAddress, string memory name, uint256 latitude, uint256 longitude, uint256 allowedDistance, uint256 requiredTime, uint256 timeTolerance, uint256 refundAmount) public onlyOwner {
        require(!drivers[driverAddress].isRegistered, "Driver is already registered");
        drivers[driverAddress] = Driver(name, latitude, longitude, allowedDistance, requiredTime, timeTolerance, refundAmount, 0, 0, true, false);
        driverAddresses.push(driverAddress);
        emit DriverRegistered(driverAddress);
    }

    function updateDriverInfo(address driverAddress, uint256 newlatitude, uint256 newlongitude, uint256 newAllowedDistance, uint256 newRequiredTime, uint256 newTimeTolerance, uint256 newRefundAmount) public onlyOwner {
        require(drivers[driverAddress].isRegistered, "Driver is not registered");
        Driver storage driver = drivers[driverAddress];
        driver.latitude = newlatitude;
        driver.longitude = newlongitude;
        driver.allowedDistance = newAllowedDistance;
        driver.requiredTime = newRequiredTime;
        driver.timeTolerance = newTimeTolerance;
        driver.refundAmount = newRefundAmount;
    }

    function ingestCoordinate(uint256 latitude, uint256 longitude, uint256 timestamp) public {
        address driverAddress = msg.sender;
        Driver storage driver = drivers[driverAddress];
        require(driver.isRegistered, "Driver is not registered");

        uint256 distance = calculatitudeeDistance(latitude, longitude, driverAddress);
        bool oldComplianceStatus = driver.isInCompliance;

        if (distance > driver.allowedDistance || timestamp < driver.requiredTime || timestamp > driver.requiredTime + driver.timeTolerance) {
            driver.isInCompliance = false;
        } else {
            driver.isInCompliance = true;
        }

        if (oldComplianceStatus != driver.isInCompliance) {
            emit ComplianceStatusChanged(driverAddress, driver.isInCompliance);
        }

        emit CoordinateIngested(driverAddress, latitude, longitude, timestamp);

        if (driver.isInCompliance) {
            driver.rating += 1;
        } else {
            if (driver.rating > 0) {
                driver.rating -= 1;
            }
        }
    }

    function getDriver(address driverAddress) public view returns (string memory, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, bool) {
        Driver memory driver = drivers[driverAddress];
        require(driver.isRegistered, "Driver is not registered");
        return (driver.name, driver.latitude, driver.longitude, driver.allowedDistance, driver.requiredTime, driver.timeTolerance, driver.refundAmount, driver.rating, driver.tokens, driver.isInCompliance);
    }

    function removeDriver(address driverAddress) public onlyOwner {
        require(drivers[driverAddress].isRegistered, "Driver is not registered");
        delete drivers[driverAddress];
        for (uint i = 0; i < driverAddresses.length; i++) {
            if (driverAddresses[i] == driverAddress) {
                driverAddresses[i] = driverAddresses[driverAddresses.length - 1];
                driverAddresses.pop();
                break;
            }
        }
    }

    function refund(address driverAddress) public onlyOwner payable {
        Driver storage driver = drivers[driverAddress];
        require(driver.isRegistered, "Driver is not registered");
        require(driver.isInCompliance, "Driver is not in compliance");
        payable(driverAddress).transfer(driver.refundAmount);
    }

    function reward(address driverAddress) public onlyOwner payable {
        Driver storage driver = drivers[driverAddress];
        require(driver.isRegistered, "Driver is not registered");
        require(driver.isInCompliance, "Driver is not in compliance");
        uint256 rewardAmount = driver.rating * 2;
        token.transfer(driverAddress, rewardAmount);
        driver.tokens += rewardAmount;
    }

    function abs(int256 x) internal pure returns (uint256) {
        return x >= 0 ? uint256(x) : uint256(-x);
    }

    function calculatitudeeDistance(uint256 latitude2, uint256 longitude2, address driverAddress) internal view returns (uint256) {
        (,uint256 latitude1, uint256 longitude1,,,,,,,) = getDriver(driverAddress);
        uint256 distance = abs(int256(latitude2) - int256(latitude1)) + abs(int256(longitude2) - int256(longitude1));
        require(distance <= type(uint256).max, "Distance calculatitudeion overflow");
        return distance;
    }
}
