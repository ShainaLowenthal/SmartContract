pragma solidity ^0.4.18;

contract Lottery {
     
     uint MainLottoFunds;        // funds up for grabs in main lotto
     uint GuessingLottoFunds;
     uint GuessingLottoTarget;       // current guessing target in guessing lotto
     uint256 MainParticipantCount;   // this keeps count of the number of main lotto participants
     address[] participantsMain;     // this holds all participant addresses in the main lotto
     address public lotteryManager;      // this is the person in charge of the lottery

    constructor() public {
        lotteryManager=msg.sender;
        MainLottoFunds=0;
        UpdateGuessingLottoTarget();
    }
     
    function MainLottoEntry() public payable {
        require(msg.value == 1 ether, "Please pay exactly one ether");      //changed msg.sender to msg.value
        //participantsMain[MainParticipantCount]=msg.sender;
        participantsMain.push(msg.sender);
        MainParticipantCount++;
        MainLottoFunds+=1;
    }
    
    function MainLottoEnd() public payable returns(uint) {
        require(msg.sender == lotteryManager);
        uint winning_index = random() % participantsMain.length;                //randomly generate winner
        participantsMain[winning_index].transfer(MainLottoFunds * 1000000000000000000); // send funds to winner
        MainLottoFunds=0;                                   // reset fund counter
        MainParticipantCount=0;                                 // reset participant counter
        delete participantsMain;                                // reset participant address array
        participantsMain = new address[](0);
        return uint(MainLottoFunds+MainParticipantCount);
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

    function getMainLottoPlayers() public view returns(address[]) {
        return participantsMain;
    } 

    function getMainLottoFunds() public view returns(uint){
        return MainLottoFunds;
    } 
    
    function getGuessingLottoFunds() public view returns(uint){
        return GuessingLottoFunds;
    } 
    
    function () public payable {
        // default blank function
    }
    
    function destroy() public  {
        if (msg.sender == lotteryManager) selfdestruct(lotteryManager);
    }
    
    function random() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, now, participantsMain)));
    }
        
    function UpdateGuessingLottoTarget() private {
        GuessingLottoTarget=random() % 10;
    }
    
} // end of contract



/// Styled according to Style Guide v0.5.13 
