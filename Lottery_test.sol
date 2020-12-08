pragma solidity >=0.4.22 <0.8.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
//import "remix_accounts.sol";
//import "../github/ShainaLowenthal/SmartContract/Lottery.sol";
import "./Lottery.sol";
// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract LottoTest {

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    
    address[] participants;
   
    Lottery lotteryToTest;

    address owner;

    uint x;

    uint y;
    
    function beforeAll() public {
        lotteryToTest = new Lottery();
        participants = lotteryToTest.getMainLottoPlayers();
        owner = lotteryToTest.getOwner();
        x = 1;
        y = 1;
    }
    
 
     function checkOwner() public
     {
        // check that the owner isn't a random person so that the lottery can't be opened or closed by anyone other than the owner
        Assert.equal(lotteryToTest.getOwner(), owner, "owner is sender");
     }
    function checkSenderAndValue() public payable {
        // checks that the sender isn't invalid
        for (uint i = 0; i < participants.length; i++)
        {
            Assert.equal(msg.sender, participants[i], "Invalid sender");
        }
        // checks that the values sent isn't invalid
        Assert.equal(msg.value, 0, "Lotto entry is 1 ether"); //why is this only running for 0 when eth receiving should be 1?
    }
 
    
    function checkFundsAndPlayersGreaterThanZeroMainLotto() public {
        while (lotteryToTest.getMainLottoFunds() > 0)
        {
            x = lotteryToTest.getMainLottoFunds();
            
            
        }
        
        while (participants.length > 0)
        {
            y = participants.length;
            Assert.equal(lotteryToTest.getMainLottoFunds(), y*1000000000000000000, "check if correct funds");
            
        }
        Assert.equal(lotteryToTest.getMainLottoFunds(), x, "No lottery if no funds");
        Assert.equal(participants.length, y, "No lottery if no partipants");       
    }
}