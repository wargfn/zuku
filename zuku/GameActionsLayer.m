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
    GameKitHelperClass *currentInstance = [GameKitHelperClass sharedInstance];
    
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
    CCLOG(turnMove);
    
    //get Previous Data if not null
    /*if(currentMatch.matchData != NULL)
    {
        //Okay append to data string
        //AND WE KNOW we already are one move in and need to cast the game
        for (GKTurnBasedParticipant *part in currentMatch.participants) 
        {
            part.matchOutcome = GKTurnBasedMatchOutcomeTied;
        }
        NSString *currentData = [NSString stringWithUTF8String:[currentMatch.matchData bytes]];
        
        NSString *sendString = [currentData stringByAppendingString:turnMove];
        NSData *data = [sendString dataUsingEncoding:NSUTF8StringEncoding ];
        
        
        [currentMatch endMatchInTurnWithMatchData:data completionHandler:^(NSError *error) 
         {
             if (error) 
             {
                 NSLog(@"%@", error);
             }
         }];
        
     
     
        //Temp space for finish function
        self.gameOver;
     
        [[CCDirector sharedDirector] pushScene:[DisplayResultsLayer scene]];

        
        
        //Temp space for finish function
        self.gameOver;
    }
    else
     */
    //{
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
    //}
    //Okay once Turn is done, roll back to the Main Menu
    [[CCDirector sharedDirector] pushScene:[MenuScreenLayer scene]];

}

-(void) displayMatchData
{
    
    //Get the Current match
    GKTurnBasedMatch *match = [[GameKitHelperClass sharedInstance]currentMatch];
    
    //Pull the DATA out of matchData
    NSString *oHolder = [NSString stringWithUTF8String:[match.matchData bytes]];
    
    CCLabelTTF *matchDisplayData = [CCLabelTTF labelWithString:(@"Match Data %@",oHolder) fontName:@"Helvetica" fontSize:20];
    CGSize size = [[CCDirector sharedDirector] winSize];
    matchDisplayData.position = ccp(5 + matchDisplayData.contentSize.width /2, size.height - matchDisplayData.contentSize.height / 2);
    
    [self addChild: matchDisplayData];
    
}


-(void)placeMatchID
{
    if ([GKLocalPlayer localPlayer].authenticated == YES)
    {    


        // ask director the the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        
        //got to get the Current Match
        GKTurnBasedMatch *currentMatch = GameKitHelperClass.sharedInstance.currentMatch;
    
        NSString *matchUID = currentMatch.matchID;
        CCLOG(@"MatchID: %@",matchUID);
    
        CCLabelTTF *matchID = [CCLabelTTF labelWithString:(@" Place MATCH ID") fontName:@"Helvetica" fontSize:18];
        matchID.position = ccp( size.width - matchID.contentSize.width /2, size.height - matchID.contentSize.height / 2);
        matchID.tag = 125;
    
        [self addChild: matchID];
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
        
        CCLabelTTF *playerAliasName = [CCLabelTTF labelWithString:(@" %@",playerAID) fontName:@"Helvetica" fontSize:18];
        playerAliasName.position = ccp( playerAliasName.contentSize.width/2, -10);
        playerAliasName.tag = 124;
       
        CCLabelTTF *playerIDName = [CCLabelTTF labelWithString:(@" %@",playerLID) fontName:@"Helvetica" fontSize:18];
        playerIDName.position = ccp( size.width - playerAliasName.contentSize.width /2 , 0 + playerIDName.contentSize.height / 2 + playerAliasName.contentSize.height);
        playerIDName.tag = 123;
         
        [self addChild: playerIDName];
        [playerIDName addChild: playerAliasName];
      
        
    }
}


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super initWithColor:ccc4(0,255,0,255)])) {
		
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
                                      
            [[CCDirector sharedDirector] pushScene:[MenuScreenLayer scene]];
        }
                                  ];
        
        CCMenuItem *completeGame = [CCMenuItemFont itemWithString:@"Complete" block:^(id sender)
            {
                for (GKTurnBasedParticipant *part in currentMatch.participants) 
                {
                    part.matchOutcome = GKTurnBasedMatchOutcomeTied;
                }
                
                NSString *sendString = [NSString stringWithFormat:@"TheEND"];
                NSData *data = [sendString dataUsingEncoding:NSUTF8StringEncoding ];

                
                [currentMatch endMatchInTurnWithMatchData:data completionHandler:^(NSError *error) 
                 {
                     if (error) 
                     {
                         NSLog(@"%@", error);
                     }
                 }];
                
                [[CCDirector sharedDirector] pushScene:[MenuScreenLayer scene]];
        }
                                    ];
        
        CCMenuItem *submitTurn = [CCMenuItemFont itemWithString:@"Send Turn" block:^(id sender)
                {
                        self.sendTurn; 
                }];
        
        CCMenuItem *notTurn = [CCMenuItemFont itemWithString:@"Not Your Turn, Return to Menu" block:^(id sender)
                {
                    //Return to MenuScreen because well ITS NOT YOUR TURN!!
                    [[CCDirector sharedDirector] replaceScene:[MenuScreenLayer scene]];
                    
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
        } 
        else {
            // it's the current match, but it's someone else's turn
            //build not your turn menu
            self.displayMatchData;
            [self addChild:noActions];
        }
        
        self.welcomePlayerID;
        self.placeMatchID;
        
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

@end
