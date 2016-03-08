# Chess
Command-line chess game made @ App Academy for two players written in Ruby. A possible moves array is generated for each player and invalid moves are rejected from play. King is prohibited from moving into check by iterating through possible moves of all opponent's pieces.

##How to run
You can run the game by navigating to the 'chess' directory and typing 'game.rb'.

##Object Oriented Implementation
* Sliding pieces and stepping piece modules mixed-in to DRY up shared methods
* Individual pieces classes (e.g. Queen) inherit from Piece superclass

##To-Do
* Use colorize gem to add color to rendered string output
