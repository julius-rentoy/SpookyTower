//
//  ScoreScene.h
//  towerGame
//
//  Created by KCU on 8/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCLabelFX.h"

@interface ScoreScene : CCLayer {
	CCLabelFX *mLabel;
}

+(id) scene;
-(id) init;
@end

@interface QuickScore: CCLayer
{
	CCLabelFX* mLabel;
	CCLabelBMFont* font30;
	NSArray* mScoreArray;
}

+ (id) scene;
- (id) init;
@end

@interface TimeAttack: CCLayer
{
	CCLabelFX *mLabel;
	CCLabelBMFont* font30;
	NSArray* mScoreArray;
}

+ (id) scene;
- (id) init;
@end

@interface ScoreAttack: CCLayer
{
	CCLabelFX *mLabel;
	CCLabelBMFont* font30;
	NSArray* mScoreArray;
}

+ (id) scene;
- (id) init;
@end
