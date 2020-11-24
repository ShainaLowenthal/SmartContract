/// pragma solidity >=0.4.0 <0.7.0; -----> UPDATE THIS
 
/// @author The Lottery Team
/// @title A lottery that will features several games
contract Lottery {
     
    ///this will represent a single entry into the lottery
    Struct Ticket {
        uint gameType;      ///Which game are they playing?
        uint gameNumber;    ///Which game of this type is this? Will increment when a lottery closes. 
        uint uniqueNumber;  ///ticket number assigned to each ticket
        uint amount;        ///cost of the ticket
        bool eliminated;    ///if they are eliminated in russian roulette
    }
 
    ///Some data structure to keep track of entries
 
    constructor() public {
    	lotteryManager=msg.sender;
    }
    
    address public lotteryManager;                      /// this is the person in charge of the lottery 
    uint public lotteryEndTime;                         /// a timestamp that will end our lottery. When the current time reaches timestamp, all entries are denied and a winning ticket is chosen. 
    bool lotteryClosed;                                 /// set to true at the lotteryEndTime. Once the prize money is delivered it will turn false again
    mapping(address => Ticket) public tickets;          /// This declares a state variable that stores a `Ticket` struct for each possible address.
    event LotteryEnded(address winner, uint amount);    /// event that will be emitted on changes
    event Guessed(address winner, uint amount);         /// This sends the winning guesser the jackpot in the guessing game
    
    ///this function will send the amount the winner will receive to the winners address
    function sendToWinner(amount) public {
        msg.sender.transfer(amount);
    }
    
    ///this function will randomly choose the winner of the lottery
    function chooseWinner() private {
        ///code
    }
    
    ///this function will randomly choose a number for the users to guess, which resets to a new random number before each new game
    function chooseTarget() private {
        ///code
    }
     
    ///this function will check if the user should be eliminated in the Russian Roulette style lottery
    function checkIfEliminated() private {
        ///code
    }

    ///this function will check if the user's guess matches the target number in the guessing game style lottery
    function checkIfGuessed() private {
        ///code
    }
     
    function destroy() public lotteryManager {
        require(msg.sender==lotteryManager);
        selfdestruct(lotteryManager);
    }
 
} /// end of contract
