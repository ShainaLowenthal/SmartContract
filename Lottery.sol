pragma solidity ^0.4.18;

contract Lottery {
	 
    uint MainLottoFunds; 		// funds up for grabs in main lotto
    uint GuessingLottoFunds;  //funds for the guessing lotto
    uint WeightedLottoFunds; //funds up for grabs in weighted lotto
    uint RRouletteLottoFunds; ///funds up for grabs in russian roulette lotto
    uint RandomRRouletteLottoFunds; //funds up for grabs in the random russian roulette
    
    uint GuessingLottoTarget; 		// current guessing target in guessing lotto
    uint RRouletteLottoTarget; //current guessing target in russian roulette
   uint RandomRRouletteLottoTarget; //current guessing target in russian roulette with random elimination

    address[] participantsMain;  	// this holds all participant addresses in the main lotto
    address[] participantsWeighted;  	// this holds all participant addresses in the main lotto
    mapping(address => uint) public weights;  /// This stores each participants betting weight
    address[] EliminatedParticipantsRRoulette;  ///This holds a list of all participants barred from the Russian roulette lotto
    mapping(address => int) public EliminatedStatus; //This tracks whether a participant is banned from the russian roulette lotto or not. By default, each address is mapped to 0, which is acceptable. When an address guesses too poorly, it is switched to -1.
    address[] EliminatedParticipantsRandomRRoulette; ///This holds a list of all participants barred from the Russian roulette lotto
    mapping(address => uint) public RandomEliminatedStatus; //This tracks whether a participant is banned from the russian roulette lotto or not. By default, each address is mapped to 0, which is acceptable. When an address guesses too poorly, it is switched to -1.


    address public lotteryManager;      // this is the person in charge of the lottery

    constructor() public {
        lotteryManager=msg.sender;
    	MainLottoFunds=0;
    	UpdateGuessingLottoTarget();
    	UpdateRRouletteLottoTarget();
    	UpdateRandomRRouletteLottoTarget();
    }
      function getOwner() public view returns (address) {
        return lotteryManager;
    } 
    function random() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, now, participantsMain)));
    }
     
    function MainLottoEntry() public payable {
	require(msg.value == 1 ether, "Please pay exactly one ether");  	//changed msg.sender to msg.value
	participantsMain.push(msg.sender);
	MainLottoFunds+=1000000000000000000;
    }
    
    function MainLottoEnd() public payable {
        require(msg.sender == lotteryManager);
	    uint winning_index = random() % participantsMain.length; 			    //randomly generate winner
	    participantsMain[winning_index].transfer(MainLottoFunds); // send funds to winner
	    MainLottoFunds=0; 								    // reset fund counter
	    delete participantsMain; 							    // reset participant address array
	    participantsMain = new address[](0);
    }    
    
    function getMainLottoPlayers() public view returns(address[]) {
        return participantsMain;
    } 


    function getMainLottoFunds() public view returns(uint){
        return MainLottoFunds;
    } 
    
    function GuessingLottoEntry(uint guess) public payable {
        require(msg.value == 1 ether, "Please pay exactly one ether");
        GuessingLottoFunds+=1;
        if (guess==GuessingLottoTarget) {
            msg.sender.transfer(GuessingLottoFunds);
            GuessingLottoFunds=0;
        }
        UpdateGuessingLottoTarget();
    }
    
    function UpdateGuessingLottoTarget() private {
        GuessingLottoTarget=random() % 10;
    }


    function getGuessingLottoFunds() public view returns(uint){
        return GuessingLottoFunds;
    } 
    
    function WeightedLottoEntry() public payable {
        weights[msg.sender]=msg.value;
        participantsWeighted.push(msg.sender);
        WeightedLottoFunds+=msg.value;
    }
    
    function WeightedLottoEnd() public{
        require(msg.sender == lotteryManager);
        uint winning_weight = random() % (WeightedLottoFunds / 1000000000000000000);
        uint current_tally=(weights[participantsWeighted[0]] / 1000000000000000000);
        uint prev_tally=0;
        if (winning_weight<=current_tally) {
            participantsWeighted[0].transfer(WeightedLottoFunds);
        }
        else {
            uint i=1;
            while (i < participantsWeighted.length) {
                prev_tally = current_tally;
                current_tally+=(weights[participantsWeighted[i]] / 1000000000000000000);
                if  (winning_weight >= prev_tally && winning_weight <= current_tally) {                            
                    participantsWeighted[i].transfer(WeightedLottoFunds);
                }
            i++;
            } 
        }
        WeightedLottoFunds=0;
        delete participantsWeighted;
	    participantsWeighted = new address[](0);
    }    

    function getWeightedLottoPlayers() public view returns(address[]) {
        return participantsWeighted;
    } 
    
    function getWeightedLottoFunds() public view returns(uint){
        return WeightedLottoFunds / 1000000000000000000;
    } 
    
    
    function RRouletteEntry(uint guess) public payable {
        require(msg.value == 1 ether, "Please pay exactly one ether");
        require(EliminatedStatus[msg.sender]!=1, "Please wait until you may enter again");

        RRouletteLottoFunds+=msg.value;
        int target_int=int(RRouletteLottoTarget);
        int guess_int=int(guess);
        int distance_int = (target_int-guess_int);
        if (distance_int < 0) {
            distance_int = 0 - distance_int;
        }
        distance_int = distance_int % 12;
        if (guess==RRouletteLottoTarget && EliminatedStatus[msg.sender]!=1) {
            msg.sender.transfer(RRouletteLottoFunds);
            RRouletteLottoFunds=0;
            for (uint i=0;i<EliminatedParticipantsRRoulette.length;i++) {
                EliminatedStatus[EliminatedParticipantsRRoulette[i]]=0;
            }
            delete EliminatedParticipantsRRoulette;
	        EliminatedParticipantsRRoulette = new address[](0);
        }
        else if (EliminatedStatus[msg.sender]==0 && distance_int > 2) {
            EliminatedParticipantsRRoulette.push(msg.sender);
            EliminatedStatus[msg.sender]=1;
        }
        UpdateRRouletteLottoTarget();
    }
    
    function UpdateRRouletteLottoTarget() private {
        RRouletteLottoTarget=random() % 12;
    }


    function getRRouletteLottoFunds() public view returns(uint){
        return RRouletteLottoFunds;
    } 
    
    function RandomRRouletteEntry(uint guess) public payable {
        require(msg.value == 1 ether, "Please pay exactly one ether");
        require(RandomEliminatedStatus[msg.sender]!=1, "Please wait until you may enter again");

        RandomRRouletteLottoFunds+=msg.value;
        if (guess==RandomRRouletteLottoTarget && RandomEliminatedStatus[msg.sender]!=1) {
            msg.sender.transfer(RandomRRouletteLottoFunds);
            RandomRRouletteLottoFunds=0;
            for (uint i=0;i<EliminatedParticipantsRandomRRoulette.length;i++) {
                RandomEliminatedStatus[EliminatedParticipantsRandomRRoulette[i]]=0;
            }
            delete EliminatedParticipantsRandomRRoulette;
	        EliminatedParticipantsRandomRRoulette = new address[](0);
        }
        else if (RandomEliminatedStatus[msg.sender]==0 && random() % 6 != 1) {
            EliminatedParticipantsRandomRRoulette.push(msg.sender);
            RandomEliminatedStatus[msg.sender]=1;
        }
        UpdateRandomRRouletteLottoTarget();
    }
    
    function UpdateRandomRRouletteLottoTarget() private {
        RandomRRouletteLottoTarget=random() % 3;
    }


    function getRandomRRouletteLottoFunds() public view returns(uint){
        return RandomRRouletteLottoFunds;
    } 
    function () public payable {
        // default blank function
    }
    
    function destroy() public  {
        if (msg.sender == lotteryManager) selfdestruct(lotteryManager);
    }
} // end of contract



/// Styled according to Style Guide v0.5.13 
