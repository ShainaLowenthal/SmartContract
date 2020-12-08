# SmartContract

## Group Members & Emails:


* Tal Bachar - Tal.Bachar59@myhunter.cuny.edu
* Shaina Lowenthal - shaina.lowenthal96@myhunter.cuny.edu
* Chloe Gottlieb - crbgott@gmail.com
* Alex Shmarkatyuk - matroskind@gmail.com
* Benjamin Pulatov (Username: Zodigram) - benjamin.pulatov@protonmail.com
* Anton Goretsky - anton.goretsky97@myhunter.cuny.edu

### NOTE: Member Contributions
All members worked in conjunction with each other during Zoom calls, using the Github account of whoever was on hand, and on their own time. The commit history is **not** representative of the work distribution on this project. **All members participated fairly and equally in the project.**

## List of Lottery Games
 1. Main Lotto
 2. Guessing Lotto
 3. Weighted Lotto
 4. Russian Roulette
 5. Random Russian Roulette

## Game Summaries:
 1. **Main Lotto** - Send 1 ether and submit a *MainLottoEntry*. When the lottery manager ends the lottory, a random address will be chosen from the pool and the main lotto funds will be transfered to their account. **End the lottery by calling *MainLottoEnd*.**
 2. **Guessing Lotto** - Send 1 ether and a guess of type uint and submit to *GuessingLottoEntry*. If your guess is correct, the guessing lotto funds will be transfered to your account. If not, you can submit another guess however you should note that the target will change after each guess is submitted. **The lotto will remain active until the correct guess is made, there is no manual end.**
 3. **Weighted Lotto** - Send however many ether you want to *WeightedLottoEntry*. When the lottery manager ends the lottery, a random address will be chosen from the pool and the weighted lotto funds will be transfered to their account. **End the lottery by calling *WeightedLottoEnd*.**
 4. **Russian Roulette** - Send 1 ether and a guess of type uint and submit to *RRouletteLottoEntry*. If your guess is correct, the Russian Roulette lotto funds will be transfered to your account. If not, whether you can submit another guess depends on how close you were to the target. Being off by more than 2 will get you blacklisted until the next round. The target will change after each guess is submitted. **The lotto will remain active until the correct guess is made, there is no manual end.**
 5. **Random Russian Roulette** - Send 1 ether and a guess of type uint and submit to *RRouletteLottoEntry*. If your guess is correct, the Russian Roulette lotto funds will be transfered to your account. If not, whether you can submit another guess depends on chance (1/6 chance to try again, 5/6 chance you are blacklisted till next round). The target will change after each guess is submitted. **The lotto will remain active until the correct guess is made, there is no manual end.**
 
### Choices Made
 * 1 ether is the required amount of entry to all lottos except the *Weighted Lotto*. This is a high stakes lottery. Games and prices were set out of creative interest for high-rollers, not the average user of Ethereum. There is inherent high risk and loss involved in entry to all lotteries.
 * The one who deploys the lottery functions as the *lotteryManager*. This user must be the one to call an end to each round of the *Main Lotto* and *Weighted Lotto*. The other lottos, by constrast, will end each round automatically in response to a correct guess.
 
## Purpose of Contract (Original Entry from Part 1 Proposal)
General Purpose: Build multiple lottery games with varying difficulties and risk. Ex: standard lottery, guessing game.
 
Initial Concept:

The purpose of this contract is to host multiple lottery “games” with varying difficulties and risk. We will begin with a simple lottery, in which a user sends ether (a fixed amount), and a winner will be declared each week, winning the entire pot.
 
A simple variation on this game can be where varying amounts of ether entered can result in varying chances of winning the complete pot.
 
Another variation could be a guessing game in which a user sends a certain amount of eth (X amount of eth for 1 guess, 2X eth for 2 guesses, etc.), as well as a guess, input as data. If and only if the user’s guess is exactly the secret number, then that user receives the whole pot. Otherwise, this game continues to run until a user finally guesses the secret target number, at which point a new secret target number generates and the game restarts.
 
A further variation of the above concept is “Russian Roulette,” in which if the number guess is too far away, the user is eliminated and has little or no chance at winning the pot. As such, this game would have a higher entry cost, fewer players, and higher winnings for those remaining.
 
Another version of “Russian Roulette” exists without a user needing to enter a guess, rather a certain number of random users will be eliminated before the lottery concludes and a winner is chosen. This could be accomplished by either randomly eliminating X users just before the random winner is selected or by eliminating a participant based on their ticket number. For example, tickets 76 and 138 cannot win the lottery. These ticket numbers can reset every round.

Revised Concept

Implement the following in Solidity:

A primary lottery in which one pays 1 ether per ticket, and a random winner is chosen when the contract owner calls an end to it/
 
A weighted variation of the primary lottery in which how much you pay influences your odds of being chosen as the random winner.
 
A guessing lottery where a target number is randomly created and participants can pay 1 eth for a single guess at that number. If and only if the user’s guess is exactly the secret number, then that user receives the whole pot. Otherwise, what they paid will simply remain in the pot until a user finally guesses the secret target number. The target number is updated every guess to eliminate process of elimination guessing.
 
A "Russian Roulette" variation of the guessing lotto that blacklists participants for the remainder of a round if their guess is off by more than 2.
 
A "Randomized" version of the “Russian Roulette” lotto which blacklists based on chance, not proximity to the target.

##  Properly Styled Interface of Contract with Function and Event Headers
This is included in a file named `interface.sol`, which can be found in this repository.
