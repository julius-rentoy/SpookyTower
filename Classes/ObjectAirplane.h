//
//  ObjectAirplane.h
//  towerGame
//
//  Created by KCU on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"

@interface ObjectAirplane : Object {
	float m_fX;
	float m_fY;
	
	float m_fStartX;
	float m_fEndX;
	CCSprite* m_SprAirplane;
}

- (id) init: (NSDictionary*) data;
- (void) draw;
@end
