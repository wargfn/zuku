//
//  AuthenticateLayer.h
//  zuku
//
//  Created by Ron Schachtner on 3/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameKitHelperClass.h"

// going to IMPORT sneakyinput to make sure it all works.
#import "ColoredCircleSprite.h"
#import "ColoredSquareSprite.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"

// HelloWorldLayer
@interface AuthenticateLayer : CCLayer <GameKitHelperClassDelegate>
{
    CCSprite *ninjaBack;
    
}


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;


@end
