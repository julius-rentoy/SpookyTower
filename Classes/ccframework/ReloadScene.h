//
//  BeginScene.h
//  towerGame
//
//  Created by KCU on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface ReloadScene : CCLayer{
	int gametype;
}
@property (nonatomic) int gametype;
+(id) scene;
-(id) init;
@end
