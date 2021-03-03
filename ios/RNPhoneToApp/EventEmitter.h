#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventEmitter : RCTEventEmitter <RCTBridgeModule>
- (void)sendStatusEventWith:(nonnull NSString *)status;
- (void)sendIncomingCallEventWith:(nonnull NSString *)caller;
@end

NS_ASSUME_NONNULL_END
