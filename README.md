# cs3340-finalProj

This was my final project for Computer Architecture.

NOTE: I have only used Mars to run this program.

### Introduction:

This program is a type of Sudoku puzzle game. Sudoku is a game where the player is presented with a puzzle formatted like Figure 1. The goal of the game is to fill in all the empty spaces with numbers. Each row, column, and square should only have one of each number from one to nine. The solution for the empty puzzle in Figure 1 is next to it in red. This puzzle is traditionally played on paper to allow the player to make changes as needed. Figure 2 shows a screen shot of what an empty puzzle in the program would look like. The zeros represent the spaces in the puzzle that still need to be filled.


### Easy Version:

This program offers two versions of sudoku. In the both versions, a puzzle is presented, and the user is prompted to enter the row and column they would like to change. If the place the user would like to change is already filled, the user is prompted to enter a different row and column number. If the space is empty, the user must then enter the value they would like to place in that spot. In the easy version, each value entered is checked for correctness as the user enters it. If the answer is incorrect, the user is informed that the number entered is invalid and is prompted to enter another value. After a correct value is entered, the updated puzzle is printed, and the program asks for another row and column the user would like to change. This continues until the puzzle is complete. The conclusion of this puzzle is seen in Figure 3.


### Hard Version: 

Like in the easy version, the user is presented a puzzle and prompted to enter the row and column that they would like to change. In the hard version, if the spot is available, meaning it was empty in the original puzzle, the user is prompted to enter the value they would like that place to hold. If the place was not empty in the original puzzle, the user must enter another row and column. Once a valid row and column are entered, the user will enter the value they would like to fill that position. In the hard version, unlike the easy version, the input is not validated upon entry. The updated puzzle is printed after each change is made. This continues until all places are filled. If the user would like to change a value they previously entered, they must simply enter the row and column of that space and proceed as if the space was empty. When the puzzle is complete, the number of spaces that were incorrect is printed. The end of the puzzle is pictured in Figure 4.


### General Use: 

To exit the program at any time, the user should enter -9. When the program is initially run, the user is prompted to enter the version of the game they would like to play. They should then play the game according to the guidelines of the versions noted above. In most cases, if the user would like to return to the previous data entry (i.e. if the user enters a row and realizes it was the wrong number and would like to enter a different row), they can enter -1 to reenter a data field. The user should not enter a string for any data fields, only integers should be entered for all data entries. Once either version of the puzzle is complete, the user will be asked if they would like to play again. If the user says yes (1), they are prompted to choose the version they would like to play as if starting the program over. If the user says no (0), the program exits. In the current version, there is only one puzzle of each version. 
