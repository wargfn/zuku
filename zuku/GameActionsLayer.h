//
//  GameActionsLayer.h
//  zuku
//
//  Created by Ron Schachtner on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "MenuScreenLayer.h"
#import "GameKitHelperClass.h"
#import "AppDelegate.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"

@interface GameActionsLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate, GameKitHelperClassDelegate>
{    
    NSString *gameData;
    NSString *matchString;
    NSString *statusLabel;
    CCLabelTTF *statusLabelTTF;
    CCSprite *highButton;
    CCSprite *midButton;
    CCSprite *lowButton;

}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void)placeMatchID;
-(void)gameOver;
-(void)sendTurn;
-(void)displayMatchData;
-(void)welcomePlayerID;
-(void)placeButtons;
-(void)getMoves;


@end
