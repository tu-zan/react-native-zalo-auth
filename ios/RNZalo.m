#import "RNZalo.h"
#import <React/RCTLog.h>
#import <React/RCTUtils.h>
#import <ZaloSDK/ZaloSDK.h>
@implementation RNZalo
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(login,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[ZaloSDK sharedInstance] unauthenticate];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *presentedViewController = RCTPresentedViewController();
        [[ZaloSDK sharedInstance] authenticateZaloWithAuthenType:ZAZAloSDKAuthenTypeViaZaloAppAndWebView
                                                parentController:presentedViewController
                                                         handler:^(ZOOauthResponseObject * response) {
            if([response isSucess]) {
                NSString * oauthCode = response.oauthCode;
                resolve(oauthCode);
            } else if(response.errorCode != kZaloSDKErrorCodeUserCancel) {
                // convert int or long to string
                NSString * errorCode = [NSString stringWithFormat:@"%ld", response.errorCode];
                NSString * message = response.errorMessage;
                NSError * error  = [
                                    NSError errorWithDomain:@"Login error"
                                    code:response.errorCode
                                    userInfo:@{NSLocalizedDescriptionKey:message}
                                    ];
                reject(errorCode, message, error);
            }
        }];
    });
}


RCT_EXPORT_METHOD(logout) {
    [[ZaloSDK sharedInstance] unauthenticate];
}

RCT_EXPORT_METHOD(getProfile: (RCTResponseSenderBlock)successCallback failureCallback: (RCTResponseErrorBlock)failureCallback) {
    [[ZaloSDK sharedInstance] getZaloUserProfileWithCallback:
     ^(ZOGraphResponseObject *response) {
        
        if(response.errorCode == kZaloSDKErrorCodeNoneError) {
            successCallback(@[response.data]);
        } else {
            failureCallback(
                            [[NSError alloc] initWithDomain:@"Zalo Oauth"
                                                       code:response.errorCode
                                                   userInfo:@{@"message": response.errorMessage}]
                            );
        }
    }];
    
}

@end
