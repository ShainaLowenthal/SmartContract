# SmartContract

## Group Members & Emails:


* Tal Bachar - Tal@Bachar.co.il
* Shaina Lowenthal - shaina.lowenthal96@myhunter.cuny.edu
* Chloe Gottlieb - crbgott@gmail.com
* Alex Shmarkatyuk - matroskind@gmail.com
* Benjamin Pulatov - benjamin.pulatov@protonmail.com
* Anton Goretsky - anton.goretsky97@myhunter.cuny.edu



## Purpose of Contract
General Purpose: Build multiple lottery games with varying difficulties and risk. Ex: standard lottery, guessing game.
 
The purpose of this contract is to host multiple lottery “games” with varying difficulties and risk. We will begin with a simple lottery, in which a user sends ether (a fixed amount), and a winner will be declared each week, winning the entire pot.
 
A simple variation on this game can be where varying amounts of ether entered can result in varying chances of winning the complete pot.
 
Another variation could be a guessing game in which a user sends a certain amount of eth (X amount of eth for 1 guess, 2X eth for 2 guesses, etc.), as well as a guess, input as data. If and only if the user’s guess is exactly the secret number, then that user receives the whole pot. Otherwise, this game continues to run until a user finally guesses the secret target number, at which point a new secret target number generates and the game restarts.
 
A further variation of the above concept is “Russian Roulette,” in which if the number guess is too far away, the user is eliminated and has little or no chance at winning the pot. As such, this game would have a higher entry cost, fewer players, and higher winnings for those remaining.
 
Another version of “Russian Roulette” exists without a user needing to enter a guess, rather a certain number of random users will be eliminated before the lottery concludes and a winner is chosen. This could be accomplished by either randomly eliminating X users just before the random winner is selected or by eliminating a participant based on their ticket number. For example, tickets 76 and 138 cannot win the lottery. These ticket numbers can reset every round.
