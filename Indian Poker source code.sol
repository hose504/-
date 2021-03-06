pragma solidity ^0.4.0;

contract SimpleIndianPoker {
    
    
    // player1 status
    string player1_name;
    address player1_address;
    uint player1_card;
    bool player1_turn;
    bool player1_have_card;
    
    uint player1_bet;
    
    
    // player2 status
    string player2_name;
    address player2_address;
    uint player2_card;
    bool player2_turn;
    bool player2_have_card;
    
    uint player2_bet;
    
    
    // game status
    bool first_game;
    uint total_bet;
    bool previous1_call;
    bool previous2_call;
    uint WhoIsWinner;
    bool game_end;
    bool previous_game_winner;
    bool have_card;
    bool turn;
    
    
    // player1 registration as "name"
    function Player1_Registration(string name) {
        player1_name=name;
        player1_address=msg.sender;
    }

    // player2 registration as "name"
    function Player2_Registration(string name) {
        player2_name=name;
        player2_address=msg.sender;
        first_game=true;
    }

    // player1 get card by random (1~10)
    function Player1getcard() returns (uint) {
    
    require (have_card==false);
    require (msg.sender==player1_address);
        
    uint randNounce1;
    uint random = uint(keccak256(now, msg.sender, randNounce1)) % 10;
    randNounce1++;
    
    if(random==1){
        player1_card=1;
    }else if (random==2){
        player1_card=2;
    }else if (random==3){
        player1_card=3;
    }else if (random==4){
        player1_card=4;
    }else if (random==5){
        player1_card=5;
    }else if (random==6){
        player1_card=6;
    }else if (random==7){
        player1_card=7;
    }else if (random==8){
        player1_card=8;
    }else if (random==9){
        player1_card=9;
    }else {
        player1_card=10;
    }
    
    }
    
    // player2 get card by random (1~10)
    function Player2getcard() returns (uint) {
    
    require (have_card==false);    
    require (msg.sender==player2_address);
        
    uint randNounce2;
    uint random2 = uint(keccak256(now, msg.sender, randNounce2)) % 10;
    randNounce2++;    
        
    if(random2==1){
        player2_card=1;
    }else if (random2==2){
        player2_card=2;
    }else if (random2==3){
        player2_card=3;
    }else if (random2==4){
        player2_card=4;
    }else if (random2==5){
        player2_card=5;
    }else if (random2==6){
        player2_card=6;
    }else if (random2==7){
        player2_card=7;
    }else if (random2==8){
        player2_card=8;
    }else if (random2==9){
        player2_card=9;
    }else {
        player2_card=10;
    }
    
    }
    
    // Only player2 can check player1's card.
    // player1 can't check own card.
    function Player1CardCheck() returns (uint) {
        require(msg.sender==player2_address);
        have_card=true;
        return player1_card;

    }
    
    // Only player1 can check player2's card.
    // player2 can't check own card.
    function Player2CardCheck() returns (uint) {
        require(msg.sender==player1_address);
        have_card=true;
        return player2_card;

    }
    
    // game start function. in first game, player1 bet first. but after first game,
    // player who is winner previous game bet first.
    // if previous game didn't have winner, then player1 bet first.
    function GameStart() {
        
        require(have_card==true);
        
        if(first_game==true){
            turn=true;
        } else if (previous_game_winner==false){
            turn=false;
            }
            else turn=true;
        previous1_call = false;
        previous2_call = false;
        
        player1_bet=100;
        player2_bet=100;
        total_bet=200;
        game_end = false;
    }
    //////////////////////////////////////////////////////// player 1 play
    function Player1_call() {
        require(have_card==true);
        require(msg.sender==player1_address);
        require(turn==true);
        require(game_end==false);
        
        previous1_call=true;
        
        turn=false;
        
        total_bet=total_bet+player2_bet;
        
        if(previous2_call==true) {
            if(player1_card>player2_card){
                WhoIsWinner=1;
                game_end=true;
                }   
                else if(player1_card<player2_card){
                WhoIsWinner=2;
                game_end=true;
                } 
                else {
                    WhoIsWinner=3;
                    game_end=true;
                }
        }
    }
    
    function Player1_raise() {
        require(have_card==true);
        require(msg.sender==player1_address);
        require(turn==true);
        require(game_end==false);
        
        player1_bet=2*player2_bet;
        total_bet=total_bet+player1_bet;

        previous1_call=false;
        turn=false;
    }
    
    function Player1_die() {
        require(have_card==true);
        require(msg.sender==player1_address);
        require(turn==true);
        require(game_end==false);

        previous1_call=false;
        
        turn=false;
        
        if(player1_card>player2_card){
            WhoIsWinner=4;
            game_end=true;
        } else {
            WhoIsWinner=5;
            game_end=true;
        }
        
    }
    //////////////////////////////////////////////////////////// player 2 play
    function Player2_call() {
        require(have_card==true);
        require(msg.sender==player2_address);
        require(turn==false);
        require(game_end==false);

        
        previous2_call=true;
        
        turn=true;
        
        total_bet=total_bet+player1_bet;
        
        if(previous1_call==true) {
            if(player1_card>player2_card){
                WhoIsWinner=1;
                game_end=true;
                } 
                else if(player1_card<player2_card){
                WhoIsWinner=2;
                game_end=true;
                } 
                else {
                    WhoIsWinner=3;
                    game_end=true;
                }
            
        }
    }
    
    function Player2_raise() {
        require(have_card==true);
        require(msg.sender==player2_address);
        require(turn==false);
        require(game_end==false);
        
        player2_bet=2*player1_bet;
        total_bet=total_bet+player2_bet;
        
        previous2_call=false;
        game_end = false;
        
        turn=true;
    }
    
    function Player2_die() {
        require(have_card==true);
        require(msg.sender==player2_address);
        require(turn==false);
        require(game_end==false);
        
        previous2_call=false;
       
         if(player2_card>player1_card){
            WhoIsWinner=6;
            game_end=true;
        } else {
            WhoIsWinner=7;
            game_end=true;
        }
        
    }
    
    function Player1_win_reward() payable {
        require(game_end == true);
        require(msg.sender==player2_address);
        
        if(WhoIsWinner==1){
            player1_address.transfer(total_bet);
        } else if (WhoIsWinner==7){
            player1_address.transfer(total_bet);
        } else if (WhoIsWinner==6){
            player1_address.transfer(2*total_bet);
        } else revert();
        
        first_game=false;
        previous_game_winner=true;
        have_card=false;
        
    }
    
    function Player2_win_reward() payable {
        require (game_end == true);
        require (msg.sender==player1_address);
        
        if(WhoIsWinner==2){
            player2_address.transfer(total_bet);
        } else if (WhoIsWinner==5){
            player2_address.transfer(total_bet);
        } else if (WhoIsWinner==4){
            player2_address.transfer(2*total_bet);
        } else revert();
        
        
        first_game=false;
        previous_game_winner=false;
        have_card=false;
    }
    
    function Draw() payable {
        require (game_end==true);
        require (WhoIsWinner==3);
        
        player1_address.transfer(total_bet/2);
        player2_address.transfer(total_bet/2);
        
        first_game=false;
        previous_game_winner=true;
        have_card=false;
    }
    
}
