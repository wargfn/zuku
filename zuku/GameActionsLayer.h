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

@interface GameActionsLayer : CCLayerColor <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate, GameKitHelperClassDelegate>
{    

}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void)placeMatchID:(GKTurnBasedMatch *)match;

@end
