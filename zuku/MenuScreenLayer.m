//
//  MenuScreenLayer.m
//  zuku
//
//  Created by Ron Schachtner on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuScreenLayer.h"

#import "AppDelegate.h"
#import "GameKitHelperClass.h"
#import "GameActionsLayer.h"


@implementation MenuScreenLayer

#pragma mark - MenuScreenLayer


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuScreenLayer *layer = [MenuScreenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super initWithColor:ccc4(0,0,255,255)])) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"MenuScreen" fontName:@"Marker Felt" fontSize:64];
        
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		
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
        
        CCMenuItem *playGame = [CCMenuItemFont itemWithString:@"Start Game" block:^(id sender)
            {
            
                
                GKMatchRequest *request = [[GKMatchRequest alloc] init];
                request.minPlayers = 2;
                request.maxPlayers = 2;
                
                GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc]initWithMatchRequest:request];
                
                mmvc.turnBasedMatchmakerDelegate = self;
                
                
                AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
                
                mmvc.showExistingMatches = YES;
                
                
                [[app navController] presentModalViewController:mmvc animated:YES];
                
            }
                                ];
		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
        
        CCMenu *menuHigh = [CCMenu menuWithItems:playGame, nil];
        
        [menuHigh alignItemsHorizontallyWithPadding:20];
        [menuHigh setPosition:ccp( size.width /2, size.height /2 + 50)];
        
		
		// Add the menu to the layer
		[self addChild:menu];
        
        //add my second menu to the layer
        [self addChild:menuHigh];
        
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

-(void) matchMakerViewControllerDidFinish:(GKMatchMakerViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController
{
    //UIViewController *tempVC;
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
    CCLOG(@"has canceled");
    
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    AppController *app = (AppController*) [[UIApplication sharedApplication]delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
    CCLOG(@"Error finding match: %@", error.localizedDescription);
}

-(void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match 
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Another game needs your attention!" message:notice 
                                                delegate:self cancelButtonTitle:@"Sweet!" otherButtonTitles:nil];
    [av show];
    [av release];
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match 
{
    //if it did find a match, I want to roll over to GameActionsLayer
    AppController *app = (AppController*) [[UIApplication sharedApplication]delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
    CCLOG(@"Printing MatchID");
    
    GKTurnBasedMatch *currentMatch = match.matchID;
    NSLog(currentMatch);
    
    
    //hoping that this assigns all varibles to what I need
    GameKitHelperClass.sharedInstance.currentMatch = match;
    
    //Need some logic here to switch between game results and a new game / Turn
    
    if( currentMatch.status == 2)
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

/*-(void)handleInviteFromGameCenter:(NSArray *)playersToInvite 
{
    //if it did find a match, I want to roll over to GameActionsLayer
    AppController *app = (AppController*) [[UIApplication sharedApplication]delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
    

    //[presentingViewController dismissModalViewControllerAnimated:YES];
    GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease]; 
    
    request.playersToInvite = playersToInvite;
    request.maxPlayers = 2;
    request.minPlayers = 2;
    GKTurnBasedMatchmakerViewController *viewController =[[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    
    viewController.showExistingMatches = NO;
    viewController.turnBasedMatchmakerDelegate = self;
    
    [[app navController] presentModalViewController:viewController animated:YES];
    [[CCDirector sharedDirector] pushScene:[GameActionsLayer scene]];
}*/

-(void)handleMatchEnded:(GKTurnBasedMatch *)match {
    NSLog(@"Game has ended");
    
    GKTurnBasedMatch *currentMatch = match;
    if ([match.matchID isEqualToString:currentMatch.matchID]) {
        //[delegate recieveEndGame:match];
        
        GameKitHelperClass.sharedInstance.currentMatch = match;
        [[CCDirector sharedDirector] pushScene:[DisplayResultsLayer scene]];
        
    } else {
        [self sendNotice:@"Another Game Ended!" forMatch:match];
    }
}



@end
