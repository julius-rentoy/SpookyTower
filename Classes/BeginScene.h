//
//  BeginScene.h
//  towerGame
//
//  Created by KCU on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ResourceManager.h"
#import "BackgroundManager.h"

@interface BeginScene : CCLayer<UIAlertViewDelegate> 
{
	BackgroundManager* backManager;
	ResourceManager* resManager;
}

+(id) scene;
-(id) init;
@end
