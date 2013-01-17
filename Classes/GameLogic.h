//
//  GameLogic.h
//  towerGame
//
//  Created by KCU on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ResourceManager.h"

@class GameLogic;
@interface GameLogic : NSObject 
{
	ResourceManager* resManager;
	NSArray* mApartmentArray;
	NSMutableArray* mObjList;
}

+ (GameLogic*) sharedGameLogic;
+ (GameLogic*) releaseGameLogic;

+ (float) getBaseLineY;
+ (void) setBaseLineY: (float) y;
+ (float) getSwingAngle;

- (id) init;
- (void) draw;
- (void) parseObjects;
@end
