#import "EventEmitter.h"

@interface EventEmitter ()
@property BOOL hasListeners;
@end

@implementation EventEmitter

RCT_EXPORT_MODULE();

+ (id)allocWithZone:(NSZone *)zone {
  static EventEmitter *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });
  return sharedInstance;
}

- (void)startObserving {
  _hasListeners = YES;
}

- (void)stopObserving {
  _hasListeners = NO;
}

- (NSArray<NSString *> *)supportedEvents {
  return @[@"onStatusChange", @"onIncomingCall"];
}

- (void)sendStatusEventWith:(nonnull NSString *)status {
  if (_hasListeners) {
    [self sendEventWithName:@"onStatusChange" body:@{ @"status": status }];
  }
}

- (void)sendIncomingCallEventWith:(nonnull NSString *)caller {
  if (_hasListeners) {
    [self sendEventWithName:@"onIncomingCall" body:@{ @"caller": caller }];
  }
}


@end
