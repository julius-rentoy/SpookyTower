#import <Foundation/Foundation.h>

@protocol BCFAdsDelegate <NSObject>

@optional

# pragma mark Popup Callbacks

- (void)popupDidReceive;
// Called when a popup is available

- (void)popupDidFail;
// Called when a popup is not available

- (void)popupDidBecomeActive;
// Called when popup is displayed

- (void)popupDidDismissActive;
// Called when user is back to the app

- (void)userWillLeaveApplication;
// Called when user clicked and is about to leave the application

# pragma mark Advertiser Callbacks

- (void)installDidReceive;
// Called if install is successfully registered

- (void)installDidFail;
// Called if install couldn't be registered


@end
