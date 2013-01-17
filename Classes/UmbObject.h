//
//  UmbObject.h
//  towerGame
//
//  Created by KCU on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceManager.h"
#import "AnimationManager.h"
@interface UmbObject : NSObject 
{
	CGPoint mTargetPosition;
	AnimationManager* mAnimManager;
	
	float m_fX;
	float m_fY;
}

- (id) init;
- (void) setTargetPosition: (CGPoint) position;
- (void) drawOnTitleScene;
@end
