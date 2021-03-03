#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>

NS_ASSUME_NONNULL_BEGIN

@class NXMCall;

@interface CallManager : NSObject <RCTBridgeModule>
@property (nullable) NXMCall *call;

+ (nonnull CallManager *)shared;
@end

NS_ASSUME_NONNULL_END
