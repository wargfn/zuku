//
//  GameKitHelperClass.m
//  zuku
//
//  Created by Ron Schachtner on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameKitHelperClass.h"

//import view controller
#import "AppDelegate.h"
#import "AuthenticateLayer.h"
#import "HelloWorldLayer.h"
#import "MenuScreenLayer.h"



@implementation GameKitHelperClass

@synthesize gameCenterAvailable;
@synthesize currentMatch;
@synthesize delegate;

#pragma mark Initialization

static GameKitHelperClass *sharedHelper = nil;
+ (GameKitHelperClass *) sharedInstance
{
    if (!sharedHelper)
    {
        sharedHelper = [[GameKitHelperClass alloc] init];
        
    }
    
    return sharedHelper;
}

-(BOOL)isGameCenterAvailable
{
    //check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    //check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *curSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([curSysVer compare:reqSysVer options:NSNumericSearch] !=NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}


-(id)init
{
    if((self = [super init]))
    {
        gameCenterAvailable = [self isGameCenterAvailable];
        if(gameCenterAvailable)
        {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
    }
    
    return self;
}

-(void)authenticationChanged
{
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated)
    {
        NSLog(@"Authentication changed; Player Authenticated.");
        NSLog(@"Player Alias: %@",[GKLocalPlayer localPlayer].alias);
        NSLog(@"Player ID: %@", [GKLocalPlayer localPlayer].playerID);
        userAuthenticated = TRUE;
        
        [[CCDirector sharedDirector] replaceScene:[MenuScreenLayer scene]];
    }
    else if(![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated)
    {
        NSLog(@"Authentication Changed; Player NOT Authorized.");
        userAuthenticated = FALSE;
        
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    }
}

#pragma mark User functions
- (void)authenticateLocalUser 
{ 
    
    if (!gameCenterAvailable) return;
    
    void (^setGKEventHandlerDelegate)(NSError *) = ^ (NSError *error)
    {
        GKTurnBasedEventHandler *ev = [GKTurnBasedEventHandler sharedTurnBasedEventHandler];
        ev.delegate = self;
    };
    
    NSLog(@"Authenticating local user...");
    
    
    //Normal Code
    if ([GKLocalPlayer localPlayer].authenticated == NO) 
    {     
        [[GKLocalPlayer localPlayer] 
         authenticateWithCompletionHandler:
         setGKEventHandlerDelegate];        
    }
    
    //End of Normal Code
    
    /*
     //Code to Clean out matches
     if ([GKLocalPlayer localPlayer].authenticated == NO) 
     {     
     [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError * error) 
     {
     [GKTurnBasedMatch loadMatchesWithCompletionHandler:^(NSArray *matches, NSError *error)
     {
     for (GKTurnBasedMatch *match in matches) 
     { 
     NSLog(@"%@", match.matchID); 
     [match removeWithCompletionHandler:^(NSError *error)
     {
     NSLog(@"%@", error);
     }]; 
     }
     }];
     }];        
     } 
     //End of Cleanout Code
     */
    
    else 
    {
        NSLog(@"Already authenticated!");
        setGKEventHandlerDelegate(nil);
    }
    
}


/* -(void)findMatchWithMinPlayers:(int)minPlayers
                    maxPlayers:(int)maxPlayers
                viewController:(UIViewController *)viewController
*/
-(void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers
{
    if(!gameCenterAvailable) return;
    
    //UIViewController *tempVC=[[UIViewController alloc] init] ;
    
    //presentingViewController = tempVC;
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
    GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc]initWithMatchRequest:request];
    
    mmvc.turnBasedMatchmakerDelegate = self;

    
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //[[app navController] presentModalViewController:mmvc animated:YES];
    
    //[[[CCDirector sharedDirector] openGLView] addSubview:tempVC.view];
    
    //tempVC.wantsFullScreenLayout = YES;
    mmvc.showExistingMatches = YES;
    
    
    [[app navController] presentModalViewController:mmvc animated:YES];
    //[presentingViewController presentModalViewController:mmvc animated:YES];
}

#pragma mark GKTurnBasedMatchmakerViewControllerDelegate
-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match 
{
    [presentingViewController dismissModalViewControllerAnimated:YES];
    
    self.currentMatch = match;
    GKTurnBasedParticipant *firstParticipant = [match.participants objectAtIndex:0];
    if (firstParticipant.lastTurnDate == NULL) 
    {
        // It's a new game!
        [delegate enterNewGame:match];
    } 
    else 
    {
        if ([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) 
        {
            // It's your turn!
            [delegate takeTurn:match];
        } 
        else 
        {
            // It's not your turn, just display the game state.
            [delegate layoutMatch:match];
        }        
    }
}

-(void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController
{
    //UIViewController *tempVC;
    [presentingViewController dismissModalViewControllerAnimated:YES];
    //[tempVC.view.superview removeFromSuperview];
    NSLog(@"has canceled");
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

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [presentingViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

-(void)handleInviteFromGameCenter:(NSArray *)playersToInvite 
{
    [presentingViewController dismissModalViewControllerAnimated:YES];
    GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease]; 
    
    request.playersToInvite = playersToInvite;
    request.maxPlayers = 12;
    request.minPlayers = 2;
    GKTurnBasedMatchmakerViewController *viewController =[[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    
    viewController.showExistingMatches = NO;
    viewController.turnBasedMatchmakerDelegate = self;
    [presentingViewController presentModalViewController:viewController animated:YES];
}

-(void)handleTurnEventForMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Turn has happened");
    if ([match.matchID isEqualToString:currentMatch.matchID]) {
        if ([match.currentParticipant.playerID 
             isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // it's the current match and it's our turn now
            self.currentMatch = match;
            [delegate takeTurn:match];
        } else {
            // it's the current match, but it's someone else's turn
            self.currentMatch = match;
            [delegate layoutMatch:match];
        }
    } else {
        if ([match.currentParticipant.playerID 
             isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // it's not the current match and it's our turn now
            [delegate sendNotice:@"It's your turn for another match" 
                        forMatch:match];
        } else {
            // it's the not current match, and it's someone else's 
            // turn
        }
    }
}

-(void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match 
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Another game needs your attention!" message:notice 
                                                delegate:self cancelButtonTitle:@"Sweet!" otherButtonTitles:nil];
    [av show];
    [av release];
}

-(void)handleMatchEnded:(GKTurnBasedMatch *)match {
    NSLog(@"Game has ended");
    if ([match.matchID isEqualToString:currentMatch.matchID]) {
        [delegate recieveEndGame:match];
    } else {
        [delegate sendNotice:@"Another Game Ended!" forMatch:match];
    }
}
@end

