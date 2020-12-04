pragma solidity ^0.4.18;

contract Lottery {
	 
    uint MainLottoFunds; 		/// funds up for grabs in main lotto
    uint GuessingLottoTarget; 		/// current guessing target in guessing lotto
    address[] participantsMain;  	/// this holds all participant addresses in the main lotto
    uint256 MainParticipantCount; 	/// this keeps count of the number of main lotto participants
    address public lotteryManager;      /// this is the person in charge of the lottery

    constructor() public {
        lotteryManager=msg.sender;
    	MainLottoFunds=0;	
    }
    
    function random() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, now, participantsMain)));
    }
     
    function MainLottoEntry() public payable {
	require(msg.value == 0.1 ether);  	///changed msg.sender to msg.value
	//participantsMain[MainParticipantCount]=msg.sender;
	participantsMain.push(msg.sender);
	MainParticipantCount++;
	MainLottoFunds+=5;
    }
    
    function MainLottoEnd() public {
        require(msg.sender == lotteryManager);
	//uint winning_index = 7;
	uint winning_index = random() % participantsMain.length;
	participantsMain[winning_index].transfer(MainLottoFunds);
	MainLottoFunds=0;
	MainParticipantCount=0;
	//delete participantsMain;
	participantsMain = new address[](0);
    }    
    
    function getPlayers() public view returns(address[]) {
        return participantsMain;
    } 
    
} /// end of contract

contract Destructible is Lottery {
    function destroy() public  {
        if (msg.sender == lotteryManager) selfdestruct(lotteryManager);
    }
}

/// Styled according to Style Guide v0.5.13 
