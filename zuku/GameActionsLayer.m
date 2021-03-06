//
//  GameActionsLayer.m
//  zuku
//
//  Created by Ron Schachtner on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameActionsLayer.h"


@implementation GameActionsLayer
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameActionsLayer *layer = [GameActionsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(void)gameOver
{
    //game is over, need to flush data and change into compelted game handler moves
    
}

- (void)sendTurn
{
    //GameKitHelperClass *currentInstance = [GameKitHelperClass sharedInstance];
    
    GKTurnBasedMatch *currentMatch = GameKitHelperClass.sharedInstance.currentMatch;
    
    NSUInteger currentIndex = [currentMatch.participants indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    
    NSUInteger nextIndex = (currentIndex + 1) % [currentMatch.participants count];
    nextParticipant = [currentMatch.participants objectAtIndex:nextIndex];
    
    for (int i = 0; i < [currentMatch.participants count]; i++) 
    {
        nextParticipant = [currentMatch.participants objectAtIndex:((currentIndex + 1 + i) % [currentMatch.participants count ])];
        if (nextParticipant.matchOutcome != GKTurnBasedMatchOutcomeQuit) 
        {
            NSLog(@"isnt' quit %@", nextParticipant);
            break;
        } 
        else 
        {
            NSLog(@"nex part %@", nextParticipant);
        }
    }
    
    
    //right now only sending strings with TheEND
    //NSString *sendString = [NSString stringWithFormat:@"TheEND"];
    //need to send data with sendString from a RANDOMLY generated number between 0 and 27
    int randomNumber = CCRANDOM_0_1() * 27;
    
    NSString *turnMove = [NSString stringWithFormat:@"%d",randomNumber];
    //Random Number Generator can GENERATE NULLS instead of 
    CCLOG(@"%@",turnMove);
    
    NSDate *currentMatchLastTurnDate = currentMatch.currentParticipant.lastTurnDate; 
    NSString *currentMatchLastTurn = [NSString stringWithFormat:@"%d",currentMatchLastTurnDate];
    
    CCLOG(@"%@",currentMatchLastTurn);
    //get Previous Data if not null
    if([currentMatch.matchData bytes] != NULL)
    {
        NSLog(@"Matched Data to Not Null");
        //Okay append to data string
        //AND WE KNOW we already are one move in and need to cast the game
        
        //Old Code Tied Everyone Up
        /*for (GKTurnBasedParticipant *part in currentMatch.participants) 
        {
            
            part.matchOutcome = GKTurnBasedMatchOutcomeTied;
        }*/
        NSString *currentData = [NSString stringWithUTF8String:[currentMatch.matchData bytes]];
        //int i = [aNumberString intValue];
        int currentMove = [currentData intValue];
        int currentTurnMove = [turnMove intValue];
        
        //Okay now that we have the Current MOVE and the Previous Move lets do some math
        if (currentMove > currentTurnMove)
        {
            for(GKTurnBasedParticipant *part in currentMatch.participants)
            {
                if ([currentMatch.currentParticipant.playerID 
                     isEqualToString:[GKLocalPlayer localPlayer].playerID])
                        {
                            part.matchOutcome = GKTurnBasedMatchOutcomeLost;
                        }
                else 
                {
                    part.matchOutcome = GKTurnBasedMatchOutcomeWon;
                }
            CCLOG(@"Lose for Current Player");
            }
        }
        else if (currentMove < currentTurnMove)
        {
            for (GKTurnBasedParticipant *part in currentMatch.participants)
            {
                
                if ([currentMatch.currentParticipant.playerID 
                     isEqualToString:[GKLocalPlayer localPlayer].playerID]) 
                        {
                            part.matchOutcome = GKTurnBasedMatchOutcomeWon;
                        }
                else 
                {
                    part.matchOutcome = GKTurnBasedMatchOutcomeLost;
                }
            CCLOG(@"Win for Current Player");
            }
        }
        else
        {
            for (GKTurnBasedParticipant *part in currentMatch.participants) 
             {
             
             part.matchOutcome = GKTurnBasedMatchOutcomeTied;
                 
             }
            CCLOG(@"Tied");
            
        }
        
        NSString *sendString = [currentData stringByAppendingString:turnMove];
        NSData *data = [sendString dataUsingEncoding:NSUTF8StringEncoding ];
        
        //[currentMatch endTurnWithNextParticipant:nextParticipant matchData:data completionHandler:^(NSError *error) 

        [currentMatch endMatchInTurnWithMatchData:data completionHandler:^(NSError *error) 
         {
             if (error) 
             {
                 NSLog(@"%@", error);
             }
         }];
        
     
     
        //Temp space for finish function
        //self.gameOver;
     
        [[CCDirector sharedDirector] pushScene:[DisplayResultsLayer scene]];

        
        
        //Temp space for finish function
        //self.gameOver;
    }
    else
    {
        NSLog(@"Made it past Null check");
        NSString *sendString = turnMove;
        NSData *data = [sendString dataUsingEncoding:NSUTF8StringEncoding ];
        [currentMatch endTurnWithNextParticipant:nextParticipant matchData:data completionHandler:^(NSError *error) 
         {
             if (error) 
             {
                 NSLog(@"%@", error);

             } 
             else 
             {

             }
         }];
        
    // Looks like Turn Submitted But I decided that instead of the Main Menu, you should go back tot he GameKit Controller, from there if you cancel, you get booted.
        GKMatchRequest *request = [[GKMatchRequest alloc] init];
        request.minPlayers = 2;
        request.maxPlayers = 2;
        
        GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc]initWithMatchRequest:request];
        
        mmvc.turnBasedMatchmakerDelegate = self;
        
        
        AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
        
        mmvc.showExistingMatches = YES;
        
        
        [[app navController] presentModalViewController:mmvc animated:YES];    
        
    //Okay once Turn is done, roll back to the Main Menu
    //[[CCDirector sharedDirector] pushScene:[MenuScreenLayer scene]];
    }

}

-(void) displayMatchData
{
    
    //Get the Current match
    GKTurnBasedMatch *match = [[GameKitHelperClass sharedInstance]currentMatch];
    
    //Pull the DATA out of matchData
    NSString *oHolder = [NSString stringWithUTF8String:[match.matchData bytes]];
    
    CCLabelTTF *matchDisplayData = [CCLabelTTF labelWithString:(oHolder) fontName:@"Helvetica" fontSize:20];
    CGSize size = [[CCDirector sharedDirector] winSize];
    matchDisplayData.position = ccp(5 + matchDisplayData.contentSize.width /2, size.height - matchDisplayData.contentSize.height / 2);
    
    [self addChild: matchDisplayData];
    
}


-(void)placeMatchID
{
    if ([GKLocalPlayer localPlayer].authenticated == YES)
    {    


        // ask director the the window size
        //CGSize size = [[CCDirector sharedDirector] winSize];
        
        
        //got to get the Current Match
        GKTurnBasedMatch *currentMatch = GameKitHelperClass.sharedInstance.currentMatch;
    
        NSString *matchUID = currentMatch.matchID;
        CCLOG(@"MatchID: %@",matchUID);
    
        //Match ID not displayable
        //CCLabelTTF *matchID = [CCLabelTTF labelWithString:(@" Place MATCH ID") fontName:@"Helvetica" fontSize:18];
        //matchID.position = ccp( size.width - matchID.contentSize.width /2, size.height - matchID.contentSize.height / 2);
        //matchID.tag = 125;
    
        //[self addChild: matchID];
    }
}

-(void)welcomePlayerID
{
    //first we test authentication
    if ([GKLocalPlayer localPlayer].authenticated == YES)
    {
        // ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

        
        //First we get the player ID, then post to screen in a label
        //[GKLocalPlayer localPlayer] *playerID = localPlayer.playerID;
        NSString *playerLID = [GKLocalPlayer localPlayer].playerID;
        NSString *playerAID = [GKLocalPlayer localPlayer].alias;
        CCLOG(@"Player ID: %@",playerLID);
        
        CCLabelTTF *playerAliasName = [CCLabelTTF labelWithString:(playerAID) fontName:@"Helvetica" fontSize:18];
        playerAliasName.position = ccp( playerAliasName.contentSize.width/2, -10);
        playerAliasName.tag = 124;
       
        CCLabelTTF *playerIDName = [CCLabelTTF labelWithString:(playerLID) fontName:@"Helvetica" fontSize:18];
        playerIDName.position = ccp( size.width - playerAliasName.contentSize.width /2 , 0 + playerIDName.contentSize.height / 2 + playerAliasName.contentSize.height);
        playerIDName.tag = 123;
         
        [self addChild: playerIDName];
        [playerIDName addChild: playerAliasName];
      
        
    }
}
-(void) placeButtons
{
    //code to place te buttons here!!!!!
    
}

-(void) getMoves
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    highButton = [CCSprite spriteWithFile:@"highbutton.png"];
    midButton = [CCSprite spriteWithFile:@"midbutton.png"];
    lowButton = [CCSprite spriteWithFile:@"lowbutton.png"];
     
    highButton.position = ccp(size.width - highButton.contentSize.width * 0.5 - 10, size.height * 0.5 + highButton.contentSize.height * 1.5);
    midButton.position = ccp(size.width - midButton.contentSize.width * 0.5 - 5, size.height *0.5);
    lowButton.position = ccp (size.width - lowButton.contentSize.width * 0.5 - 10, size.height * 0.5 - lowButton.contentSize.height * 1.5);
    
    [self addChild: highButton z:1];
    [self addChild: midButton z:1];
    [self addChild: lowButton z:1];
    
    
    //Getting tags Review this 
    [statusLabelTTF setString:[NSString stringWithFormat:@"Select First Move"]];
    
    
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init ])) 
    {
	
        // implementing color as a layer instead of initWithColor
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(0,255,0,255)];
        [self addChild:colorLayer z:-1];
        
        // initializng my gameData string
        gameData = nil;
        statusLabel = nil;
        
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"GameActionsLayer" fontName:@"Marker Felt" fontSize:64];
        
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
        GKTurnBasedMatch *currentMatch = [[GameKitHelperClass sharedInstance] currentMatch];
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
		}
									   ];
        
		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
		}
									   ];
		
        
        CCMenuItem *cancelItem = [CCMenuItemFont itemWithString:@"Cancel" block:^(id sender)
            {
                GKMatchRequest *request = [[GKMatchRequest alloc] init];
                request.minPlayers = 2;
                request.maxPlayers = 2;
                
                GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc]initWithMatchRequest:request];
                
                mmvc.turnBasedMatchmakerDelegate = self;
                
                
                AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
                
                mmvc.showExistingMatches = YES;
                
                
                [[app navController] presentModalViewController:mmvc animated:YES];    
                
                     
                // Originally Dumped you back to Main Menu, I want GameKit UI move
                // [[CCDirector sharedDirector] replaceScene:[MenuScreenLayer scene]];
        }
                                  ];
        
        CCMenuItem *completeGame = [CCMenuItemFont itemWithString:@"Complete" block:^(id sender)
            {
                for (GKTurnBasedParticipant *part in currentMatch.participants) 
                {
                    part.matchOutcome = GKTurnBasedMatchOutcomeTied;
                }
                
                NSString *sendString = [NSString stringWithFormat:@"Match Quit"];
                NSData *data = [sendString dataUsingEncoding:NSUTF8StringEncoding ];

                
                [currentMatch endMatchInTurnWithMatchData:data completionHandler:^(NSError *error) 
                 {
                     if (error) 
                     {
                         NSLog(@"%@", error);
                     }
                 }];
                
                //Return to GameKit Menu
                GKMatchRequest *request = [[GKMatchRequest alloc] init];
                request.minPlayers = 2;
                request.maxPlayers = 2;
                
                GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc]initWithMatchRequest:request];
                
                mmvc.turnBasedMatchmakerDelegate = self;
                
                
                AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
                
                mmvc.showExistingMatches = YES;
                
                
                [[app navController] presentModalViewController:mmvc animated:YES];    
                

               // [[CCDirector sharedDirector] pushScene:[MenuScreenLayer scene]];
        }
                                    ];
        
        CCMenuItem *submitTurn = [CCMenuItemFont itemWithString:@"Send Turn" block:^(id sender)
                {
                        [self sendTurn]; 
                }];
        
        CCMenuItem *notTurn = [CCMenuItemFont itemWithString:@"Not Your Turn, Return to Menu" block:^(id sender)
                {
                    //Return to MenuScreen because well ITS NOT YOUR TURN!!
                    // But I decided that instead of the Main Menu, you should go back tot he GameKit Controller, from there if you cancel, you get booted.
                    GKMatchRequest *request = [[GKMatchRequest alloc] init];
                    request.minPlayers = 2;
                    request.maxPlayers = 2;
                    
                    GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc]initWithMatchRequest:request];
                    
                    mmvc.turnBasedMatchmakerDelegate = self;
                    
                    
                    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
                    
                    mmvc.showExistingMatches = YES;
                    
                    
                    [[app navController] presentModalViewController:mmvc animated:YES];    
                    
                    //Not your Turn Return to the GameKit Menu
                    //[[CCDirector sharedDirector] replaceScene:[MenuScreenLayer scene]];
                    
                }];
        
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
       
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
        
        CCMenu *actions = [CCMenu menuWithItems:cancelItem, completeGame, submitTurn, nil];
        [actions alignItemsHorizontallyWithPadding:20];
        [actions setPosition:ccp( size.width / 2, size.height /2 +50)];
        
        CCMenu *noActions = [CCMenu menuWithItems:notTurn, nil];
        [noActions alignItemsHorizontallyWithPadding:20];
        [noActions setPosition:ccp( size.width / 2, size.height /2 +50)];
		
		// Add the menu to the layer
		[self addChild:menu];

        //Need to say current player show this menu or else the other menu
        //if (GKTurnBasedParticipantStatusActive
        if ([currentMatch.currentParticipant.playerID 
             isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // it's the current match and it's our turn now
           [self addChild:actions];
            [self placeButtons];
            [self getMoves];
            

        } 
        else {
            // it's the current match, but it's someone else's turn
            //build not your turn menu
            [self displayMatchData ];
            [self addChild:noActions];
        }
        
        [self welcomePlayerID ];
        [self placeMatchID];
                
        //Okay Setting up the Layer for the ACTUAL game Play and not my Temp Code
        
        statusLabel = [NSString stringWithString:@"Start Fight!!!!"];
        statusLabelTTF = [CCLabelTTF labelWithString:statusLabel fontName:@"Helvetica" fontSize:16];
        statusLabelTTF.position = ccp(0 + statusLabelTTF.contentSize.width, 0 + statusLabelTTF.contentSize.height);
        [self addChild:statusLabelTTF z:0 tag:0123];
        
        
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) matchMakerViewControllerDidFinish:(GKMatchMakerViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
    [[CCDirector sharedDirector] replaceScene:[MenuScreenLayer scene]];
}

-(void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController
{
    //UIViewController *tempVC;
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
    CCLOG(@"has canceled");
    [[CCDirector sharedDirector] replaceScene:[MenuScreenLayer scene]];
    
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    AppController *app = (AppController*) [[UIApplication sharedApplication]delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
    CCLOG(@"Error finding match: %@", error.localizedDescription);
    [[CCDirector sharedDirector] replaceScene:[MenuScreenLayer scene]];
}

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match 
{
    //if it did find a match, I want to roll over to GameActionsLayer
    AppController *app = (AppController*) [[UIApplication sharedApplication]delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
    CCLOG(@"Printing MatchID");
    
    GKTurnBasedMatch *currentMatch = match;
    //matchString = [NSString stringWithUTF8String:[currentMatch.matchID bytes]];
    matchString = currentMatch.matchID;
    CCLOG(@"%@",matchString);
    
    
    //hoping that this assigns all varibles to what I need
    GameKitHelperClass.sharedInstance.currentMatch = match;
    
    //Need some logic here to switch between game results and a new game / Turn
    
    if( match.status == 2)
    {
        //If Match is over switch to the DisplayResultsLayer
        CCLOG(@"Game is OVER, Switching to DisplayResultsLayer");
        [[CCDirector sharedDirector] replaceScene:[DisplayResultsLayer scene]];
        
    }
    else {
        
        //If match is not over then go to GameActionsLayer
        CCLOG(@"Switching to GameActionsLayer");
        [[CCDirector sharedDirector] replaceScene:[GameActionsLayer scene]];
    }
    
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match {
    NSUInteger currentIndex = 
    [match.participants indexOfObject:match.currentParticipant];
    GKTurnBasedParticipant *part;
    
    for (int i = 0; i < [match.participants count]; i++) {
        part = [match.participants objectAtIndex:
                (currentIndex + 1 + i) % match.participants.count];
        if (part.matchOutcome != GKTurnBasedMatchOutcomeQuit) {
            break;
        } 
    }
    NSLog(@"playerquitforMatch, %@, %@", 
          match, match.currentParticipant);
    [match participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeQuit nextParticipant:part matchData:match.matchData completionHandler:nil];
}

//These lines needed for the GameKitHelperClassDelegate
#pragma mark GameKitHelperClassDelegate
- (void)enterNewGame:(GKTurnBasedMatch *)match
{
    
}

- (void)layoutMatch:(GKTurnBasedMatch *)match
{
    
}

- (void)takeTurn:(GKTurnBasedMatch *)match
{
    
}
- (void)recieveEndGame:(GKTurnBasedMatch *)match
{
    
}
- (void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match
{
    
}



@end
