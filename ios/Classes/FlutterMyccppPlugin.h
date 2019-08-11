#import <Flutter/Flutter.h>
#import <my2c2pSDK/My2c2pSDK.h>

@interface FlutterMyccppPlugin : NSObject<FlutterPlugin> {
    NSString * privateKey;
    BOOL productionMode;
}

@property (nonatomic, strong) My2c2pSDK * my2c2pSDK;

@end
