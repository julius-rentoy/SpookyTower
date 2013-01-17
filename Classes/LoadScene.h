//
//  HelloWorldLayer.h
//  towerGame
//
//  Created by KCU on 6/13/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "ResourceManager.h"

// HelloWorld Layer
@interface LoadScene : CCLayer
{
	ResourceManager* resManager;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

@end
