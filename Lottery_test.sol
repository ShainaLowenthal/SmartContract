pragma solidity >=0.4.22 <0.8.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.;
import "./Lottery.sol";
// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract LottoTest {
    
    // declaring vars that will be defined in beforeAll()
    address[] participants;
   
    Lottery lotteryToTest;

    address owner;

    uint x;

    uint y;
    
    // 'beforeAll' runs before all other tests
    // previously declared vars are defined here
    function beforeAll() public {
        lotteryToTest = new Lottery();
        participants = lotteryToTest.getMainLottoPlayers();
        owner = lotteryToTest.getOwner();
        x = 1;
        y = 1;
    }
    
    // check that the owner isn't a random person so that the lottery can't be opened or closed by anyone other than the owner
    function checkOwner() public
    {
       Assert.equal(lotteryToTest.getOwner(), owner, "owner is sender"); // checks if the owner address is the correct address
    }
    
    // checks that the sender and values aren't invalid
    function checkSenderAndValue() public payable {        
        for (uint i = 0; i < participants.length; i++) // checks that the sender isn't invalid by iterating over list of participants
        {
            Assert.equal(msg.sender, participants[i], "Invalid sender");
        }        
        Assert.equal(msg.value, 0, "Lotto entry is 1 ether"); // checks that the values sent isn't invalid
    }
 
    // checks that the lottery is even possible i.e. if there are any participants and funds
    function checkFundsAndPlayersGreaterThanZeroMainLotto() public {
        while (lotteryToTest.getMainLottoFunds() > 0) 
        {
            x = lotteryToTest.getMainLottoFunds(); // resets lottery funds var x if there are funds available
        }
        
        while (participants.length > 0) 
        {
            y = participants.length; // resets lottery participants var y if there are participants available
            Assert.equal(lotteryToTest.getMainLottoFunds(), y*1000000000000000000, "check if correct funds"); // checks if the funds are correct based on the number of participants
        }
        Assert.equal(lotteryToTest.getMainLottoFunds(), x, "No lottery if no funds"); // checks if lottery is possible based on funding
        Assert.equal(participants.length, y, "No lottery if no partipants"); // checks if lottery is possible based on participants
    }
}
