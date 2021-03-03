#import "CallManager.h"
#import <NexmoClient/NexmoClient.h>

@implementation CallManager

RCT_EXPORT_MODULE();

+ (nonnull CallManager *)shared {
  static CallManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [CallManager new];
  });
  return sharedInstance;
}

RCT_EXPORT_METHOD(callAccepted) {
  [CallManager.shared.call answer:nil];
}

RCT_EXPORT_METHOD(callRejected) {
  [CallManager.shared.call reject:nil];
}

@end
