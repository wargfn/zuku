//
//  HelloWorldLayer.h
//  zuku
//
//  Created by Ron Schachtner on 3/4/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


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
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, GameKitHelperClassDelegate>
{


}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;


@end
