// Raffle

// Enter the lottery (paying some amount)

// Pick a random winner (verifiably random)

// Winner to be selected every X minutes -> completly automated

// Chainlink Oracle -> Randomness, Automated Execution (Chainlink Keeper)

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";

error Raffe__NotEnoughETHEntered();
error Raffe__TransferFailed();

contract Raffle is VRFConsumerBaseV2{
    /* State Variables */
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;
    VRFCoordinatorV2Interface i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private immutable i_callBackGasLimit;
    uint32 private constant NUM_WORDS = 1;

    /* Events */
    event RaffleEnter(address indexed player);
    event RequestedRaffleWinner(uint256 indexed requestId);
    event WinnerPicked(address indexed winner);

    // Lottert Variables
    address private s_recentWinner;

    // VRFConsumerBaseV2 is the super constructor
    constructor(address vrfCoordinatorV2, uint256 entranceFee,
     bytes32 gasLane, uint64 subscriptionId, uint32 callBackGasLimit) VRFConsumerBaseV2(vrfCoordinatorV2){
        i_entranceFee = entranceFee;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callBackGasLimit = callBackGasLimit;
    }

    function enterRaffle() public payable{
        // require msg.value > i_entranceFee
        if(msg.value < i_entranceFee){
            revert Raffe__NotEnoughETHEntered();
        }

        // Events - whenever we update a dynamic object, like an array or a mapping
        // we always want to omit an event, in this case s_players
    
        // EVM will log when things happen on blockchain and stored to structure called logs
        // We can read these logs from our blockchain nodes when run
        // Inside logs is an important piece of logging called events
        // Events allow we to "print" stuff to this log in a way more gas efficient than saving in storage variable
        // These events and logs live special data structure that isn't accessible to smart contracts
        // Each one of these events is tied to the smart contract or account address emitted this event in these transactions 
    
        // event storeNumber{
        //      uint256 indexed oldNumber,
        //      uint256 indexed newNumber,
        //      uint 256 addedNumber,
        //      address sender
        // );
        //

        // emit storedNumber(
        //      favoriteNumber,
        //      _favoriteNumber,
        //      _favoriteNumber + favoriteNumber,
        //      msg.sender
        // );

        // when we omint one of these events, there are two kinds of parameters
        // The indexed parameters and the non indexed parameters, we can have up to three index parameters
        // Indexed parameters also known as = Topics, its much easier to search and query than non index parameters
        // Non indexed parameters are harder to search because they are ABI encoded and have to know the API in order to decode them
   
        // Named events with the function name reversed
        s_players.push(payable( msg.sender));
        emit RaffleEnter(msg.sender);
    }   

    // Chain links VRF 2, Chain links keeper
    // this function will called by the chain link keepers network so that can auto run without interact
    // external function cheaper than public, use external because solidity know our own contract can call this
    function requestRandomWinner() external{
        // Request the random number
        // Once we get it, do something with it
        // 2 transaction process, this is to avoid brute froce manipulation

        uint256 requestId =  i_vrfCoordinator.requestRandomWords(
            i_gasLane, // gasLane
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callBackGasLimit,
            NUM_WORDS
        );

        emit RequestedRaffleWinner(requestId);
    }

    // we will override the virtual function fulfillRandomWords in chainlink VRFConsumerBaseV2.sol one
    function fulfillRandomWords(uint256 /*requestId*/, uint256[] memory randomWords) 
        internal 
        override
    {
        // s_players size 10
        // randomNumber 202
        // 202 % 10 = 2
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        // sent all the money in this contract to this address
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        // require(sucess)
        if(!success) {
          revert Raffe__TransferFailed();
        }

        emit WinnerPicked(recentWinner);
    }


    // View is Pure functions
    function getEntranceFee() public view returns (uint256){
        return i_entranceFee;
    }

    function getPlayer(uint256 index) public view returns(address){
        return s_players[index];
    } 

    
    function getRecentWinner() public view returns(address){
        return s_recentWinner;
    } 

}
