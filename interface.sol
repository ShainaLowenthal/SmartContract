// pragma solidity ^0.4.18;
 
/// @author The Lottery Team
/// @title A lottery that will features several games
contract Lottery {
     
    //this will represent a single entry into the lottery
    Struct Ticket {
        uint gameType;      // Which game are they playing?
        uint gameNumber;    // Which game of this type is this? Will increment when a lottery closes. 
        uint uniqueNumber;  // Ticket number assigned to each ticket
        uint amount;        // Cost of the ticket
        bool eliminated;    // If they are eliminated in russian roulette
    }
 
    constructor() public {
        lotteryManager=msg.sender;
    }
    
    address public lotteryManager;                      // This is the person in charge of the lottery 
    uint public lotteryEndTime;                         // A timestamp that will end our lottery. When the current time reaches timestamp, all entries are denied and a winning ticket is chosen. 
    bool lotteryClosed;                                 // Set to true at the lotteryEndTime. Once the prize money is delivered it will turn false again
    mapping(address => Ticket) public tickets;          // This declares a state variable that stores a `Ticket` struct for each possible address.
    event LotteryEnded(address winner, uint amount);    // Event that will be emitted on changes
    event Guessed(address winner, uint amount);         // This sends the winning guesser the jackpot in the guessing game
    
    // Send the amount the winner will receive to the winners address
    function sendToWinner(amount) public {
        msg.sender.transfer(amount);
    }
    
     function destroy() public lotteryManager {
        require(msg.sender==lotteryManager);
        selfdestruct(lotteryManager);
    }
    
    // randomly choose the winner of the lottery
    function chooseWinner() private {
        //code
    }
    
    // randomly choose a number for the users to guess, which resets to a new random number before each new game
    function chooseTarget() private {
        //code
    }
     
    // check if the user should be eliminated in the Russian Roulette style lottery
    function checkIfEliminated() private {
        //code
    }

    // check if the user's guess matches the target number in the guessing game style lottery
    function checkIfGuessed() private {
        //code
    }
     
 
} // end of contract

