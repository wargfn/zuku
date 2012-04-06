//
//  DisplayResultsLayer.m
//  zuku
//
//  Created by Ron Schachtner on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DisplayResultsLayer.h"
#import "GameActionsLayer.h"
#import "AppDelegate.h"

#pragma mark - DisplayResultsLayer
@implementation DisplayResultsLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DisplayResultsLayer *layer = [DisplayResultsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) displayMatchData
{
    
    //Get the Current match
    GKTurnBasedMatch *match = [[GameKitHelperClass sharedInstance]currentMatch];
    
    //Pull the DATA out of matchData
    NSString *oHolder = [NSString stringWithUTF8String:[match.matchData bytes]];
    
    CCLabelTTF *matchDisplayData = [CCLabelTTF labelWithString:(@"Match Data %@",oHolder) fontName:@"Helvetica" fontSize:20];
    CGSize size = [[CCDirector sharedDirector] winSize];
    matchDisplayData.position = ccp(size.width / 2, size.height - matchDisplayData.contentSize.height / 2);
    
    [self addChild: matchDisplayData];
    
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init])) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Display Results" fontName:@"Marker Felt" fontSize:64];
        
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
        
        //Adding the Buttons to return to the MenuScreenLayer when down with Display Results
        CCMenuItem *returnButton = [CCMenuItemFont itemWithString:@"Return To Menu" block:^(id sender)
            {
                
                //return to MenuScreenLayer
                CCLOG(@"Returning to Menu");
                //[[CCDirector sharedDirector] replaceScene:[MenuScreenLayer scene]];
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
        
        CCMenu *returnMenu = [CCMenu menuWithItems: returnButton, nil];
        
        [returnMenu alignItemsHorizontallyWithPadding:20];
        [returnMenu setPosition:ccp( size.width/2, size.height/2 +50)];
		
		// Add the menu to the layer
		[self addChild:menu];
        [self addChild:returnMenu];
        
        self.displayMatchData;
        
        CCSprite *frame = [CCSprite spriteWithFile:@"frame.png"];
        frame.position = ccp( size.width /2, size.height /2);
        
        [self addChild:frame z:40 tag:1101];
        
        //need display functions HERE
        
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
    
    GKTurnBasedMatch *currentMatch = match.matchID;
    NSLog(currentMatch);
    
    
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
