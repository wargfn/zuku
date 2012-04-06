//
//  AuthenticateLayer.m
//  zuku
//
//  Created by Ron Schachtner on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthenticateLayer.h"

// Need to import Navigation Controller
#import "AppDelegate.h"
#import "MenuScreenLayer.h"
#import "GameKitHelperClass.h"

#pragma mark - AuthenticateLayer

@implementation AuthenticateLayer



// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AuthenticateLayer *layer = [AuthenticateLayer node];
    
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
    // signed this screen to be RED
	if( (self=[super initWithColor:ccc4(255,0,0,255)])) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Authenticating..." fontName:@"Marker Felt" fontSize:32];
        
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		//label.position =  ccp( size.width /2 , size.height/2 );
        //Didnt like the MIDDLE of the screen Placement So Bottoming it out
        label.position = ccp( size.width /2, 16);
		
		// add the label as a child to this Layer
		[self addChild: label z:1];
        
        //Adding the Ninja to the BACKGROUND
        ninjaBack = [CCSprite spriteWithFile:@"zuku_ninja.png"];
        
        ninjaBack.position = ccp( size.width/2, ninjaBack.contentSize.height / 2 + 16);
        //ninjaBack.scale = 2.0f;
        
        [self addChild:ninjaBack z:0 tag:1456];
        
        //Adding the Authentication Check HERE
        //Authenticate User
        [[GameKitHelperClass sharedInstance] authenticateLocalUser];
        

        
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
