#import "FlutterMyccppPlugin.h"
#import <my2c2pSDK/My2c2pSDK.h>

@interface FlutterMyccppPlugin()

- (void)setup;

- (void)requestPayment: (NSDictionary *)params result: (FlutterResult)result;
- (void)requestRecurringPayment: (NSDictionary *)params result: (FlutterResult)result;
- (void)requestInstallmentPayment: (NSDictionary *)params result: (FlutterResult)result;
- (void)requestAlternativePayment: (NSDictionary *)params result: (FlutterResult)result;
- (void)requestPaymentChannel: (NSDictionary *)params result: (FlutterResult)result;

- (void)sendRequest: (FlutterResult)result;

- (void)setMandatoryFields: (NSDictionary *)params;
- (void)setCardInfoFields: (NSDictionary *)params;
- (void)setRecurringFields: (NSDictionary *)params;
- (void)setRecurringFields: (NSDictionary *)params;
- (void)setInstallmentFields: (NSDictionary *)params;
- (void)setAlternativePaymentFields: (NSDictionary *)params;
- (void)setPaymentChannelFields: (NSDictionary *)params;
- (int)paymentChannelFromString: (NSString *)string;
- (void)setOptionalFields: (NSDictionary *)params;

- (void)nilSafeSetPropertyValue: (NSObject *)value forKey: (NSString *)key;
- (void)nilSafeSetBoolPropertyValue: (NSObject *)value forKey: (NSString *)key;

@end

@implementation FlutterMyccppPlugin

+ (void)registerWithRegistrar: (NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_myccpp"
            binaryMessenger:[registrar messenger]];
  FlutterMyccppPlugin* instance = [[FlutterMyccppPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall: (FlutterMethodCall *)call result: (FlutterResult)result
{
    NSLog(@">>>>>>>>>>>>>>>>>>>>>> handleMethodCall");
    NSLog(@"Dictionary: %@", [call.arguments description]);

    NSLog(call.method);
    NSDictionary * params = call.arguments;

    if ([@"getPlatformVersion" isEqualToString:call.method])
    {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }

    else if ([@"initialize" isEqualToString:call.method])
    {
        NSLog(@"initialize");
        privateKey = params[@"privateKey"];
        productionMode = [params[@"productionMode"] boolValue];

        result(nil);
    }

    else if ([@"requestAlternativePayment" isEqualToString:call.method])
    {
        NSLog(@"requestAlternativePayment");
        [self setup];
        [self requestAlternativePayment:params result:result];
    }

    else if ([@"requestPayment" isEqualToString:call.method])
    {
        NSLog(@"requestPayment");
        [self setup];
        [self requestPayment:params result:result];
    }

    else
    {
        NSLog(@"FlutterMethodNotImplemented");
        result(FlutterMethodNotImplemented);
    }
}

- (void)setup
{
    _my2c2pSDK = [[My2c2pSDK alloc] initWithPrivateKey: privateKey];
    _my2c2pSDK.version = 9.0;
    _my2c2pSDK.productionMode = productionMode;
}

- (void)requestPayment: (NSDictionary *)params result: (FlutterResult)result
{
    NSLog(@"Request payment params: %@", params);

    [self setMandatoryFields: params];
    [self setCardInfoFields: params];
    [self setOptionalFields: params];

    [self sendRequest: result];
}

- (void)requestRecurringPayment: (NSDictionary *)params result: (FlutterResult)result
{
    NSLog(@"Request recurring payment params: %@", params);

    [self setMandatoryFields: params];
    [self setCardInfoFields: params];
    [self setRecurringFields: params];
    [self setOptionalFields: params];

    [self sendRequest: result];
}

- (void)requestInstallmentPayment: (NSDictionary *)params result: (FlutterResult)result
{
    NSLog(@"Request installment payment params: %@", params);

    [self setMandatoryFields: params];
    [self setCardInfoFields: params];
    [self setInstallmentFields: params];
    [self setOptionalFields: params];

    [self sendRequest: result];
}

- (void)requestAlternativePayment: (NSDictionary *)params result: (FlutterResult)result
{
    NSLog(@"Request alternative payment params: %@", params);

    [self setMandatoryFields: params];
    [self setAlternativePaymentFields: params];
    [self setOptionalFields: params];

    [self sendRequest: result];
}

- (void)requestPaymentChannel: (NSDictionary *)params result: (FlutterResult)result
{
    NSLog(@"Request payment channel payment params: %@", params);

    [self setMandatoryFields: params];
    [self setPaymentChannelFields: params];
    [self setOptionalFields: params];

    [self sendRequest: result];
}

- (void)sendRequest: (FlutterResult)result
{
    // Determine what controller is in the front based on if the app has a navigation controller or a tab bar controller
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIViewController* showingController;

    if ([window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        NSLog(@"UINavigationController");
        showingController = ((UINavigationController*)window.rootViewController).visibleViewController;
    }

    else if ([window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        NSLog(@"UITabBarController");
        showingController = ((UITabBarController*)window.rootViewController).selectedViewController;
    }

    else
    {
        NSLog(@"UIViewController");
        showingController = (UIViewController*)window.rootViewController;
    }

    _my2c2pSDK.delegate = showingController;

    dispatch_async(dispatch_get_main_queue(), ^{
        [_my2c2pSDK requestWithTarget: showingController
                           onResponse: ^(NSDictionary *response){
                               NSLog(@"success: %@", response);
                               result(response);
                           }
                               onFail:^(NSError *error) {
                                   if (error) {
                                       NSLog(@"error: %@", error);
                                       result([FlutterError errorWithCode:[NSString stringWithFormat:@"Error %ld", error.code]
                                                                  message:error.domain
                                                                  details:error.localizedDescription]);
                                   } else {
                                       result([FlutterError errorWithCode:[NSString stringWithFormat:@"TRANSACTION_CANCELED"]
                                                                  message: @"TRANSACTION_CANCELED"
                                                                  details: @"Transaction is canceled"]);
                                   }
                               }];
    });
}

- (void)setMandatoryFields: (NSDictionary *)params
{
    _my2c2pSDK.merchantID = params[@"merchantID"];
    _my2c2pSDK.uniqueTransactionCode = params[@"uniqueTransactionCode"];
    _my2c2pSDK.desc = params[@"desc"];
    _my2c2pSDK.amount = [params[@"amount"] doubleValue];
    _my2c2pSDK.currencyCode = params[@"currencyCode"];
    _my2c2pSDK.secretKey = params[@"secretKey"];

    [self nilSafeSetBoolPropertyValue: params[@"paymentUI"] forKey: @"paymentUI"];
}

- (void)setCardInfoFields: (NSDictionary *)params
{
    _my2c2pSDK.cardHolderName = params[@"cardHolderName"];
    _my2c2pSDK.cardHolderEmail = params[@"cardHolderEmail"];
    _my2c2pSDK.storeCardUniqueID = params[@"storeCardUniqueID"];
    _my2c2pSDK.pan = params[@"pan"];
    _my2c2pSDK.cardExpireMonth = [params[@"cardExpireMonth"] intValue];
    _my2c2pSDK.cardExpireYear = [params[@"cardExpireYear"] intValue];
    _my2c2pSDK.securityCode = params[@"securityCode"];
    _my2c2pSDK.panCountry = params[@"panCountry"];
    _my2c2pSDK.panBank = params[@"panBank"];
    _my2c2pSDK.request3DS = params[@"request3DS"];
    _my2c2pSDK.storeCard = params[@"storeCard"];
}

- (void)setRecurringFields: (NSDictionary *)params
{
    _my2c2pSDK.recurring = YES;
    _my2c2pSDK.invoicePrefix = params[@"invoicePrefix"];
    _my2c2pSDK.recurringInterval = [params[@"recurringInterval"] intValue];
    _my2c2pSDK.recurringAmount = [params[@"recurringAmount"] doubleValue];
    _my2c2pSDK.recurringCount = [params[@"recurringCount"] intValue];
    [self nilSafeSetBoolPropertyValue: params[@"allowAccumulate"] forKey: @"allowAccumulate"];
    [self nilSafeSetPropertyValue:params[@"maxAccumulateAmt"] forKey:@"maxAccumulateAmt"];
    [self nilSafeSetPropertyValue:params[@"chargeNextDate"] forKey:@"chargeNextDate"];
    [self nilSafeSetPropertyValue:params[@"promotion"] forKey:@"promotion"];
}

- (void)setInstallmentFields: (NSDictionary *)params
{
    _my2c2pSDK.ippTransaction = YES;
    _my2c2pSDK.installmentPeriod = [params[@"installmentPeriod"] intValue];
    _my2c2pSDK.interestType = params[@"interestType"];
}

- (void)setAlternativePaymentFields: (NSDictionary *)params
{
    _my2c2pSDK.paymentChannel = [self paymentChannelFromString:params[@"paymentChannel"]];
    _my2c2pSDK.cardHolderName = params[@"cardHolderName"];
    _my2c2pSDK.cardHolderEmail = params[@"cardHolderEmail"];
    _my2c2pSDK.agentCode = params[@"agentCode"];
    [self nilSafeSetPropertyValue:params[@"channelCode"] forKey:@"channelCode"];
    [self nilSafeSetPropertyValue:params[@"paymentExpiry"] forKey:@"paymentExpiry"];
    [self nilSafeSetPropertyValue:params[@"mobileNo"] forKey:@"mobileNo"];
}

- (void)setPaymentChannelFields: (NSDictionary *)params
{
    _my2c2pSDK.paymentChannel = [self paymentChannelFromString:params[@"paymentChannel"]];
}

- (int)paymentChannelFromString: (NSString *)string
{
    NSDictionary *paymentChannelDictionary =
    @{@"MPU": [NSNumber numberWithInt:MPU],
      @"UPOP": [NSNumber numberWithInt:UPOP],
      @"ALIPAY": [NSNumber numberWithInt:ALIPAY],
      @"ONE_TWO_THREE": [NSNumber numberWithInt:ONE_TWO_THREE],
      @"MASTER_PASS": [NSNumber numberWithInt:MASTER_PASS],
      @"APPLE_PAY": [NSNumber numberWithInt:APPLE_PAY],
      @"QWIK": [NSNumber numberWithInt:QWIK],
      @"LINE_PAY": [NSNumber numberWithInt:LINE_PAY]};
    return [paymentChannelDictionary[string] intValue];
}

- (void)setOptionalFields: (NSDictionary *)params
{
    [self nilSafeSetPropertyValue: params[@"payCategoryID"] forKey:@"payCategoryID"];
    [self nilSafeSetPropertyValue: params[@"userDefined1"] forKey:@"userDefined1"];
    [self nilSafeSetPropertyValue: params[@"userDefined2"] forKey:@"userDefined2"];
    [self nilSafeSetPropertyValue: params[@"userDefined3"] forKey:@"userDefined3"];
    [self nilSafeSetPropertyValue: params[@"userDefined4"] forKey:@"userDefined4"];
    [self nilSafeSetPropertyValue: params[@"userDefined5"] forKey:@"userDefined5"];
    [self nilSafeSetPropertyValue: params[@"statementDescriptor"] forKey:@"statementDescriptor"];
}

- (void)nilSafeSetPropertyValue: (NSObject *)value forKey: (NSString *)key
{
    if (value && ![value isEqual:[NSNull null]]) {
        [_my2c2pSDK setValue: value forKey:key];
    }
}

- (void)nilSafeSetBoolPropertyValue: (NSObject *)value forKey: (NSString *)key
{
    if (value && ![value isEqual:[NSNull null]]) {
        [_my2c2pSDK setValue: (NSNumber *)value forKey:key];
    }
}

@end
