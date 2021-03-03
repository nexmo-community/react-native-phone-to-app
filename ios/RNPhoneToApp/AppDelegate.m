#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTDevLoadingView.h>
#import <React/RCTComponent.h>

#import <NexmoClient/NexmoClient.h>
#import <AVFoundation/AVFoundation.h>

#import "EventEmitter.h"
#import "CallManager.h"

@interface AppDelegate () <NXMClientDelegate>
@property NXMClient *client;
@property EventEmitter *eventEmitter;
@property CallManager *callManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  
#if RCT_DEV
  [bridge moduleForClass:[RCTDevLoadingView class]];
#endif
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"RNPhoneToApp"
                                            initialProperties:nil];
  
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  
  [AVAudioSession.sharedInstance requestRecordPermission:^(BOOL granted) {
    NSLog(@"Allow microphone use. Response: %d", granted);
  }];
  
  self.eventEmitter = [bridge moduleForClass:[EventEmitter class]];
  
  [self setupClient];
  
  return YES;
}

- (void)setupClient {
  self.client = NXMClient.shared;
  [self.client setDelegate:self];
  [self.client loginWithAuthToken:@"ALICE_JWT"];
}

#pragma mark - NXMClientDelegate

- (void)client:(nonnull NXMClient *)client didChangeConnectionStatus:(NXMConnectionStatus)status reason:(NXMConnectionStatusReason)reason {
  dispatch_async(dispatch_get_main_queue(), ^{
    switch (status) {
      case NXMConnectionStatusConnected:
        [self.eventEmitter sendStatusEventWith:@"Connected"];
        break;
      case NXMConnectionStatusConnecting:
        [self.eventEmitter sendStatusEventWith:@"Connecting"];
        break;
      case NXMConnectionStatusDisconnected:
        [self.eventEmitter sendStatusEventWith:@"Disconnected"];
        break;
    }
  });
}

- (void)client:(nonnull NXMClient *)client didReceiveError:(nonnull NSError *)error {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.eventEmitter sendStatusEventWith:error.localizedDescription];
  });
}

- (void)client:(nonnull NXMClient *)client didReceiveCall:(nonnull NXMCall *)call {
  dispatch_async(dispatch_get_main_queue(), ^{
    CallManager.shared.call = call;
    NSString *caller = call.otherCallMembers.firstObject.channel.from.data;
    [self.eventEmitter sendIncomingCallEventWith:caller];
  });
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
