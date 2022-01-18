// SPDX-license-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves; //a state variable. Stored permanently on the contract storage.

    // This is to aid get a random number
    uint private seed;


    // This does the magic of carrying out an event which involves capturing the address
    // time of transaction and message left by the users of our application.
    event NewWave(address indexed from, uint256 timestamp, string message);

   


    // Then create a struct that holds value like an object.
    struct Wave {
        address waver; //The address of the user who waved.
        string message; //The message the user sends.
        uint256 timestamp; //The time the user waved while interacting with the dapp.
    }

    // To hold the values, we make the struct an array
    Wave[] waves;

    // The mapping helps associate an action to an address
    mapping(address => uint256) public lastWavedAt;

    // Add an event to 
    // This constructor allows the logging of our messages without any passed value.
    constructor() payable {
        console.log("We have been constructed!");

        // Set the initial seed which is set once
        seed = (block.timestamp + block.difficulty) % 100;
    }

    // This function makes it possible for users to make a wave and adds to the 
    // initialized unit256 totalWaves created at the top of the codebase.
    // This initialization is a zero = 0.
    function wave(string memory _message) public {
        // totalWaves += 1;
        // console.log("%s has waved", msg.sender, _message); //The msg.sender is the address of the user of our application.
        // Before a user interact with smart contracts, the user much first link a verifiable and valid wallet.
        // This is similar to the the web2 authentication that allows you perform some activity after logging in.
        
        require(lastWavedAt[msg.sender] + 30 seconds < block.timestamp, "Wait 30 seconds before waving again.");

        // Update the current timestamp we have from the user.
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved", msg.sender);


        // The storage of the waves into an array is done here.
        waves.push(Wave(msg.sender, _message, block.timestamp));


        // Generate another seed for user of our web app
        seed = (block.timestamp + block.difficulty) % 100;

        console.log("Random # generated: %id", seed);

        // Give a 50% chance that the user wins the price
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance, 
                "Trying to withdraw more money than the contract has");
            (bool success, ) = (msg.sender).call{value: prizeAmount}('');
            require(success, "Failed to withdraw money from contract.");
        }

        // The emit carries out the event created within the function. 
        // The event function above helps gets the address, message and the timestamp of the transaction.
        emit NewWave(msg.sender, block.timestamp, _message);
         // This shows the amount to be awarded to users of our dapp
    
    }

    // This is the getAllWaves to retrieve the number of waves
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }


    // This function gets the total number of waves that was made by the 
    // users of our application and return them to allow accessibility.
    function getTotalWaves() public view returns (uint256) {
        // This is to help show the total waves.
        // console.log("We have %d total waves", totalWaves);
        return totalWaves;
    }    

}   