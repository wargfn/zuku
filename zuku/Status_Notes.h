//
//  Header.h
//  zuku
//
//  Created by Ron Schachtner on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// File to Keep track of Tasks and Notes
//
// -- - Initial Project Setup & Initial icons
// -- - Based on a Cocos2D project for movie manipulation
// -- - Still pointed at HelloWorldLayer
// 00 - Initial Copies of GCTurnBasedMatchHelper
// 01 - Implementation of GCTurnBasedMatchHelper
// 02 - Implementation of GK Authentication, seeing "Welcome Back Player" on Hello World Screen
// 03 - Retun Varibles for GKPlayerID into Cocos2d text Label on Hello World Layer
// 04 - WelcomeScreen added to reat players after they are authenticated.  Going to show an error screen when players cancel out of Game Center, everything requires it.
// Flow is HelloWorld, Authenticate, then Welcome Screen to go to Game Center to play, Weclome Screen = Main menu
// 05 - Welcome Screen move people to Game Center - Testing

// Trashed all changes. 3/4/2012
// Changed implementations into version 2.x which has direct GameKit integrations
// -- inital Project Setup & icons
// -- setup game sceens to push me through what was going on with GameKit
// -- Created Basic display pages to roll through the GameKit.
// -- Changes to Authentication and to force player authentication
// -- Added Sneaky buttons and joystick just in case.
// -- Added Authentication Screen to REd, and the Ninja in the background
// -- Do I need to just add everything I need to GameKitHelper Class so I can just write the code once

// 3/10/2012
// 00 - Add numerous functions, game now rolls between all game modes as required
// 00 - Still broken when it is not the current players turn, need to add a detection
// 00 - Otherwise errors happen trying to submit completeions, CHANGE menus based on current Turn
// 01 - Now handleing Not your turn, return to menu, displaying completed games


#ifndef zuku_Header_h
#define zuku_Header_h
#endif
