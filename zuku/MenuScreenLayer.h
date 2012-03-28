//
//  MenuScreenLayer.h
//  zuku
//
//  Created by Ron Schachtner on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameKitHelperClass.h"
#import "DisplayResultsLayer.h"

// going to IMPORT sneakyinput to make sure it all works.
#import "ColoredCircleSprite.h"
#import "ColoredSquareSprite.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"

// HelloWorldLayer
@interface MenuScreenLayer : CCLayerColor <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, GKTurnBasedMatchmakerViewControllerDelegate, GKMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate,GameKitHelperClassDelegate>
{
    int velocityXb, velocityYb, velocityXw, velocityYw;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
