//
//  GKAchievementHandler.m
//
//  Created by Benjamin Borowski on 9/30/10.
//  Copyright 2010 Typeoneerror Studios. All rights reserved.
//  $Id$
//

#import <GameKit/GameKit.h>
#import "GKAchievementHandler.h"
#import "GKAchievementNotification.h"
#import "towerGameAppDelegate.h"
//   #import "AppDelegate.h"
static GKAchievementHandler *defaultHandler = nil;

#pragma mark -

@interface GKAchievementHandler(Private)

- (void)displayNotification:(GKAchievementNotification *)notification;

@end

#pragma mark -

@implementation GKAchievementHandler(Private)

- (void)displayNotification:(GKAchievementNotification *)notification
{
    if (self.image != nil)
    {
        [notification setImage:self.image];
    }
    else
    {
        [notification setImage:nil];
    }
	
	NSLog(@"DISPLAY!!!");
	
    [_topView addSubview:notification];
    [notification animateIn];
}

@end

#pragma mark -

@implementation GKAchievementHandler

@synthesize image=_image;

#pragma mark -

+ (GKAchievementHandler *)defaultHandler
{
    if (!defaultHandler) defaultHandler = [[self alloc] init];
    return defaultHandler;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
//        _topView = [[UIApplication sharedApplication] keyWindow];
		//_topView = ((UIViewController*)((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController).view;

        _topView    =   ((UIViewController *)[[towerGameAppDelegate getInstance] getRootViewController]).view;
        
		_queue = [[NSMutableArray alloc] initWithCapacity:0];
        self.image = [UIImage imageNamed:@"gk-icon.png"];
    }
    return self;
}

- (void)dealloc
{
    [_queue release];
    [_image release];
    [super dealloc];
}

#pragma mark -

- (void)notifyAchievement:(GKAchievementDescription *)achievement
{
    GKAchievementNotification *notification = [[[GKAchievementNotification alloc] initWithAchievementDescription:achievement] autorelease];
    notification.frame = kGKAchievementDefaultSize;
    notification.handlerDelegate = self;

    [_queue addObject:notification];
    if ([_queue count] == 1)
    {
        [self displayNotification:notification];
    }
    

}

- (void)notifyAchievementTitle:(NSString *)title andMessage:(NSString *)message
{
    GKAchievementNotification *notification = [[[GKAchievementNotification alloc] initWithTitle:title andMessage:message] autorelease];
    notification.frame = kGKAchievementFrameStartLandscapeRight;
    notification.handlerDelegate = self;

    [_queue addObject:notification];
    if ([_queue count] == 1)
    {
        [self displayNotification:notification];
    }
}

#pragma mark -
#pragma mark GKAchievementHandlerDelegate implementation

- (void)didHideAchievementNotification:(GKAchievementNotification *)notification
{
    [_queue removeObjectAtIndex:0];
    if ([_queue count])
    {
        [self displayNotification:(GKAchievementNotification *)[_queue objectAtIndex:0]];
    }
}

@end
