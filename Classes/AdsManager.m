//
//  AdsManager.m
//  Bottle Tunes
//
//  Created by Jason Pawlak on 9/2/11.
//  Copyright 2011 Paw Apps LLC. All rights reserved.
//

#import "AdsManager.h"
#import "Mobclix.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include "AppSpecificValues.h"
//#define MOBCLIX_ID @"E0CC0E6A-4CE0-4893-A9D6-B05208A5510D"

@implementation AdsManager

@synthesize adView;
@synthesize adStarted;

static AdsManager *_sharedAdsManager = nil;

// Helper methods

-(UIViewController*) getRootViewController
{
	return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void) presentViewController:(UIViewController*)vc
{
	UIViewController* rootVC = [self getRootViewController];
	[rootVC presentModalViewController:vc animated:YES];
}

-(NSString *) platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

-(void) newAd:(CGPoint)loc {
    
    if (adView) {
        // We only want one ad at a time
        [self cancelAd];
    }
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    bool is3GDevice = [[self platform] isEqualToString:@"iPhone1,2"];

    if (is3GDevice) {
        adView = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(-1 * (winSize.height/2 - 25 - loc.y), 160 - 25 + loc.x, 320.0f, 50.0f)] autorelease];
        [adView setTransform:CGAffineTransformMakeRotation(M_PI / 2.0)];
    } 
    else if(winSize.width > 728) {
        adView = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(loc.x+10,winSize.height - 100.0f, 728.0f, 90.0f)] autorelease];
    } 
    
    else {
        adView = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(loc.x, winSize.height - loc.y - 50.0f, 320.0f, 50.0f)] autorelease];
    }
    //    [[[self getRootViewController] view] addSubview:adView];
    [[[CCDirector sharedDirector] openGLView] addSubview:adView];
    
    [self.adView resumeAdAutoRefresh];
}

-(void) showAd {
    if (!adView)
        [self newAd:ccp(0,0)];
    [self.adView resumeAdAutoRefresh];
    [self.adView setHidden:NO];
}

-(void) hideAd {
    [self.adView pauseAdAutoRefresh];
    [self.adView setHidden:YES];
}

-(void) cancelAd {
    // Can only cancel it if it exists
    if (adView) {
        [adView cancelAd];
        [adView setDelegate:nil];
        [adView removeFromSuperview];
        adView = nil;
    }
}

-(void) startMobclix {
    if (!adStarted)
        adStarted = YES;
    [Mobclix startWithApplicationId:MOBCLIX_ID];
}

+(AdsManager*)sharedAdsManager
{
	@synchronized([AdsManager class])
	{
		if (!_sharedAdsManager)
			[[self alloc] init];
        
		return _sharedAdsManager;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([AdsManager class])
	{
		NSAssert(_sharedAdsManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedAdsManager = [[super alloc] init];
		return _sharedAdsManager;
	}
    
	return nil;
}

-(id)autorelease {
    [self cancelAd];
    
    return self;
}

-(id)init {
    if (!adStarted)
        [self startMobclix];
	return [super init];
}

@end