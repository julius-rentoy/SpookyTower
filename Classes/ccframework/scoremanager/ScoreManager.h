//
//  ScoreManager.h
//  fruitGame
//
//  Created by KCU on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLDatabase.h"

@interface ScoreManager : NSObject {
	SQLDatabase*	m_sqlManager;
}

+ (ScoreManager*) sharedScoreManager;
+ (void) releaseScoreManager;

- (id) init;
- (NSArray*) loadAllScore;
- (NSArray*) loadAllQuickScore;
- (NSArray*) loadAllTimeScore;

- (void) submitScore: (NSString*) scoreName score: (int) score;
- (void) submitQuickScore: (NSString*) scoreName score: (int) score;
- (void) submitTimeScore: (NSString*) scoreName score: (int) score;

- (BOOL) isTop5ForScore: (int) score;
- (BOOL) isTop5ForQuickScore: (int) score;
- (BOOL) isTop5ForTimeScore: (int) score;

- (BOOL) isTop: (int) score;
- (void) resetScore;
@end
