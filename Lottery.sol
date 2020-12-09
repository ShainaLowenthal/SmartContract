pragma solidity ^0.4.18;

contract Lottery {
	 
    uint MainLottoFunds; 		// funds up for grabs in main lotto
    uint GuessingLottoFunds;  		// funds up for grabs in guessing lotto
    uint WeightedLottoFunds; 		// funds up for grabs in weighted lotto
    uint RRouletteLottoFunds; 		// funds up for grabs in russian roulette lotto
    uint RandomRRouletteLottoFunds; 	// funds up for grabs in the random russian roulette
	
    uint GuessingLottoTarget; 		// current guessing target in guessing lotto
    uint RRouletteLottoTarget; 		// current guessing target in russian roulette
    uint RandomRRouletteLottoTarget; 	// current guessing target in russian roulette with random elimination
    
    uint GuessingLottoDifficulty; 	//current guessing difficulty for Guessing Lotto
    uint RRouletteLottoDifficulty;	//current guessing difficulty for Russian Roulette Lotto
    uint RandomRRouletteLottoDifficulty; //current guessing difficulty for Randomized Russian Roulette Lotto

    address[] participantsMain;  	// this holds all participant addresses in the main lotto
    address[] participantsWeighted;  	// this holds all participant addresses in the weighted lotto
    mapping(address => uint) public weights;  	// This stores each participants betting weight in the weighted lotto
    address[] EliminatedParticipantsRRoulette;  //This holds a list of all participants barred from the Russian roulette lotto
    mapping(address => int) public EliminatedStatus; //This tracks whether a participant is banned from the russian roulette lotto or not. By default, each address is mapped to 0, which is acceptable. When an address guesses too poorly, it is switched to -1.
    address[] EliminatedParticipantsRandomRRoulette; //This holds a list of all participants barred from the randomized Russian roulette lotto
    mapping(address => uint) public RandomEliminatedStatus; //This tracks whether a participant is banned from the randomized russian roulette lotto or not. By default, each address is mapped to 0, which is acceptable. When an address guesses too poorly, it is switched to -1.
    address public lotteryManager;     			    // this is the person in charge of the lottery

    constructor() public {
        lotteryManager=msg.sender; //set the owner to the contract creator
        MainLottoFunds=0; //no funds at first in Main Lotto
	    GuessingLottoFunds=0; //no funds at first in Guessing Lotto
	    WeightedLottoFunds=0; //no funds at first in Weighted Lotto
	    RRouletteLottoFunds=0; //no funds at first in Russian Roulette Lotto
	    RandomRRouletteLottoFunds=0; //no funds at first in Randomized Russian Roulette Lotto
	    GuessingLottoDifficulty = 10;
	    RRouletteLottoDifficulty = 10;
	    RandomRRouletteLottoDifficulty=10;
	    UpdateGuessingLottoTarget(); //create initial target for Guessing lotto
	    UpdateRRouletteLottoTarget(); //create initial target for Russian Roulette Lotto
        UpdateRandomRRouletteLottoTarget(); //create initial target for Randomized Russian Roulette Lotto

    }
    
      function getOwner() public view returns (address) { //check who the owner is
        return lotteryManager; 
    } 
    
    function random() private view returns(uint) { //generate "random" number
        return uint(keccak256(abi.encodePacked(block.difficulty, now, participantsMain)));
    }
     
    function MainLottoEntry() public payable { //Pay 1 eth to be added to pool of competitors
	require(msg.value == 1 ether, "Please pay exactly one ether");
	participantsMain.push(msg.sender);
	MainLottoFunds+=msg.value; //add 1 eth to pot
    }
    
    function MainLottoEnd() public payable returns(uint) { //Pay out winner of Main Lotto
        require(msg.sender == lotteryManager); //can only be executed by owner
	    uint winning_index = random() % participantsMain.length; 	//randomly generate winner
	    participantsMain[winning_index].transfer(MainLottoFunds); 	// send funds to winner
	    MainLottoFunds=0; 						// reset fund counter
	    delete participantsMain; 					// reset participant address array
	    participantsMain = new address[](0);
    }    
    
    function getMainLottoPlayers() public view returns(address[]) { //See who is participating in the Main Lotto
        return participantsMain;
    } 

    function getMainLottoFunds() public view returns(uint) { //See how much eth is up for grabs in the Main Lotto
        return MainLottoFunds;
    } 
    
    function GuessingLottoEntry(uint guess) public payable { //Pay one eth for chance to guess target and win pot
        require(msg.value == 1 ether, "Please pay exactly one ether"); 
        GuessingLottoFunds+=msg.value; //Add payment to Guessing Lotto pot
        if (guess==GuessingLottoTarget) { //Only when guess is exactly right
            msg.sender.transfer(GuessingLottoFunds); //Transfer pot to winner
            GuessingLottoFunds=0; //Reset pot
        }
        UpdateGuessingLottoTarget(); //Choose new target every guess to avoid process of elimination
    }

    function UpdateGuessingLottoTarget() private { //Choose new guessing target
        GuessingLottoTarget=random() % GuessingLottoDifficulty; //Range based on difficulty
    }
    
    function UpdateGuessingLottoDifficulty(uint new_difficulty) public { //Update difficulty for Guessing Lotto
        require(msg.sender == lotteryManager); //Can only be updated by owner of contract
	    GuessingLottoDifficulty=new_difficulty;
    } 
    
    function getGuessingLottoFunds() public view returns(uint){ //See how much eth is up for grabs in the Guessing Lotto
        return GuessingLottoFunds; 
    } 
    
    function WeightedLottoEntry() public payable { //Pay however much you want to enter the Weighted lotto
    	require(msg.value % 1000000000000000000 == 0, "Please only pay in exact eth"); //Pay exclusively in eth, not wei
        weights[msg.sender]=msg.value; //Your address is mapped to how much you paid to enter
        participantsWeighted.push(msg.sender); //You are recorded as a participant
        WeightedLottoFunds+=msg.value; //The money you paid is added to the pot
    }
    
    function WeightedLottoEnd() public {
        require(msg.sender == lotteryManager); //Can only be ended by owner of contract
        uint winning_weight = random() % (WeightedLottoFunds  / 1000000000000000000); //Choose a random weight (winner contributed weight in this interval)
        uint current_tally=(weights[participantsWeighted[0]]  / 1000000000000000000); //Identify how much first participant contributed to weight
        uint prev_tally=0;
        if (winning_weight<=current_tally) { //See if first participant won
            participantsWeighted[0].transfer(WeightedLottoFunds); //If so, give them the pot
        }
        else { //Otherwise
            uint i=1;
	    uint winner_found=0;
            while (i < participantsWeighted.length && winner_found==0) { //iterate through participants until you find your winner
                prev_tally = current_tally; //set lower end of interval being checked
                current_tally+=(weights[participantsWeighted[i]] / 1000000000000000000); //set higher end of interval being checked
                if  (winning_weight >= prev_tally && winning_weight <= current_tally) { //see if interval user contributed contains winning weight           
                    participantsWeighted[i].transfer(WeightedLottoFunds); //If so, give them the pot
		    winner_found=1; //Note that you've already found your winner
                }
            i++; //Move on to the next participant
            } 
        }
        WeightedLottoFunds=0; //Reset the pot
        delete participantsWeighted; //Reset the participants
	    participantsWeighted = new address[](0);
    }    

    function getWeightedLottoPlayers() public view returns(address[]) { //Check who's participating in the Weighted Lotto
        return participantsWeighted;
    } 
    
    function getWeightedLottoFunds() public view returns(uint) { //See how much eth is up for grabs in the Weighted Lotto
        return WeightedLottoFunds;
    } 
    
    function RRouletteEntry(uint guess) public payable { //Pay 1 eth to participate in the Russian Roulette Lotto
        require(msg.value == 1 ether, "Please pay exactly one ether");
        require(EliminatedStatus[msg.sender]!=1, "Please wait until you may enter again"); //Cannot participate again if eliminated in this round
        RRouletteLottoFunds+=msg.value; //Add funds to pot if amount paid is acceptable and participant not eliminated previously
        int target_int=int(RRouletteLottoTarget);
        int guess_int=int(guess);
        int distance_int = (target_int-guess_int);
        if (distance_int < 0) {
            distance_int = 0 - distance_int;
        }
        distance_int = distance_int % int(RRouletteLottoDifficulty); //Distance between guess and Russian Roulette Target
        if (guess==RRouletteLottoTarget) { //Check if user guessed correctly
            msg.sender.transfer(RRouletteLottoFunds); //If so, give them the pot
            RRouletteLottoFunds=0; //Reset the pot
            for (uint i=0;i<EliminatedParticipantsRRoulette.length;i++) { //Unban all banned participants in preparation for the next round
                EliminatedStatus[EliminatedParticipantsRRoulette[i]]=0;
            }
            delete EliminatedParticipantsRRoulette; //Clear list of blacklisted addresses
	    EliminatedParticipantsRRoulette = new address[](0);
        }
        else if (distance_int > 2) { //If guess was wrong and it was off by more than 2
            EliminatedParticipantsRRoulette.push(msg.sender); //You get blacklisted
            EliminatedStatus[msg.sender]=1;
        }
        UpdateRRouletteLottoTarget(); //Choose new target every guess to avoid process of elimination
    }
    
    function UpdateRRouletteLottoTarget() private { //Choose new target for the Russian Roulette lotto
        RRouletteLottoTarget=random() % RRouletteLottoDifficulty;
    }

    function UpdateRRouletteLottoDifficulty(uint new_difficulty) public { //Update difficulty for Russian Roulette
        require(msg.sender == lotteryManager); //Can only be updated by owner of contract
	    RRouletteLottoDifficulty=new_difficulty;
    } 
    
    function getRRouletteLottoFunds() public view returns(uint) { //See how much is up for grabs in the Russian Roulette lotto
        return RRouletteLottoFunds;
    } 
    
    function RandomRRouletteEntry(uint guess) public payable { //Pay 1 eth to enter the Randomized Russian Roulette lotto
        require(msg.value == 1 ether, "Please pay exactly one ether");
        require(RandomEliminatedStatus[msg.sender]!=1, "Please wait until you may enter again");

        RandomRRouletteLottoFunds+=msg.value; //add payment to pot
        if (guess==RandomRRouletteLottoTarget) { //If your guess is exactly right
            msg.sender.transfer(RandomRRouletteLottoFunds); //You get the pot
            RandomRRouletteLottoFunds=0; //Reset the pot
            for (uint i=0;i<EliminatedParticipantsRandomRRoulette.length;i++) { //Go through list of eliminated participants
                RandomEliminatedStatus[EliminatedParticipantsRandomRRoulette[i]]=0; //Remove them from the blacklist
            }
            delete EliminatedParticipantsRandomRRoulette;
	        EliminatedParticipantsRandomRRoulette = new address[](0);
        }
        else if (random() % 6 != 1) { //1/6 chance you can try again
            EliminatedParticipantsRandomRRoulette.push(msg.sender); //if you fail, you're blacklisted
            RandomEliminatedStatus[msg.sender]=1;
        }
        UpdateRandomRRouletteLottoTarget(); //Choose new target every guess to avoid process of elimination
    }
    
    function UpdateRandomRRouletteLottoTarget() private { //Choose new Randomized Russian Roulette number
        RandomRRouletteLottoTarget=random() % RandomRRouletteLottoDifficulty; //Target based on Difficulty
    }

    function UpdateRandomRRouletteLottoDifficulty(uint new_difficulty) public { //Update difficulty for Randomized Russian Roulette
        require(msg.sender == lotteryManager); //Can only be updated by owner of contract
	    RandomRRouletteLottoDifficulty=new_difficulty;
    } 
    
    function getRandomRRouletteLottoFunds() public view returns(uint) { //See how much is up for grabs in Randomized Russian Roulette Lotto
        return RandomRRouletteLottoFunds;
    } 
    

    
    function () public payable {
        msg.sender.transfer(msg.value);
    }
    
    function destroy() public  {
        if (msg.sender == lotteryManager) selfdestruct(lotteryManager);
    }
    
} // end of contract


/// Styled according to Style Guide v0.5.13 
