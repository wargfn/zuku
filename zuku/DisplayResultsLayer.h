//
//  DisplayResultsLayer.h
//  zuku
//
//  Created by Ron Schachtner on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "MenuScreenLayer.h"
#import "AppDelegate.h"


@interface DisplayResultsLayer : CCLayerColor <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate, GameKitHelperClassDelegate>  {
    
}
+(CCScene *) scene;

-(void)displayMatchData;

@end
