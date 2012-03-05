//
//  GameKitHelperClass.h
//  zuku
//
//  Created by Ron Schachtner on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

@protocol GameKitHelperClassDelegate
- (void)enterNewGame:(GKTurnBasedMatch *)match;
- (void)layoutMatch:(GKTurnBasedMatch *)match;
- (void)takeTurn:(GKTurnBasedMatch *)match;
- (void)recieveEndGame:(GKTurnBasedMatch *)match;
- (void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match;
@end

@interface GameKitHelperClass : NSObject <GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate> 
    {
        BOOL gameCenterAvailable;
        BOOL userAuthenticated;
        UIViewController *presentingViewController;
        
        GKTurnBasedMatch *currentMatch;
        
        id <GameKitHelperClassDelegate> delegate;
    }
    
@property (nonatomic, retain) id <GameKitHelperClassDelegate> delegate;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (nonatomic, retain) GKTurnBasedMatch *currentMatch;
    
+ (GameKitHelperClass *)sharedInstance;
- (void)authenticateLocalUser;
- (void)authenticationChanged;
//- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController;
-(void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers;
@end