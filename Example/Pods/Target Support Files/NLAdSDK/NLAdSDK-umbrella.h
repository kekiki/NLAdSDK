#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NLAdAttribute.h"
#import "NLAdDefines.h"
#import "NLAdLog.h"
#import "NLAdManager+NativeAd.h"
#import "NLAdManager+ReadAd.h"
#import "NLAdManager+RewardAd.h"
#import "NLAdManager.h"
#import "NLAdModelProtocol.h"
#import "NLAdReadAdView.h"
#import "NLAdSDK.h"

FOUNDATION_EXPORT double NLAdSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char NLAdSDKVersionString[];

