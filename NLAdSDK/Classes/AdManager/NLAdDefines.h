//
//  NLAdDefines.h
//  Novel
//
//  Created by Ke Jie on 2020/9/13.
//  Copyright © 2020 panling. All rights reserved.
//

#ifndef NLAdDefines_h
#define NLAdDefines_h

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

/// 广告平台定义
typedef NS_ENUM(NSInteger, NLAdPlatform) {
    NLAdPlatformAdmob = 1,          //Google AdMob
    NLAdPlatformFacebook = 2,       //Facebook
    NLAdPlatformMoPub = 3,       //MoPub
};

/**
广告位代码定义
http://wiki.local/pages/viewpage.action?pageId=3803267
*/

// 原生广告位代码
typedef NS_ENUM(NSInteger, NLNativeAdPlaceCode) {
    NLNativeAdPlaceCodeSplash = 1000,//开屏
    NLNativeAdPlaceCodeNovelRead = 1001,//小说阅读
    NLNativeAdPlaceCodeComicRead = 1002,//漫画阅读
    NLNativeAdPlaceCodeNovelBottom = 1003,//小说底部
    NLNativeAdPlaceCodeComicBottom = 1004,//漫画底部
};

// 激励广告位代码
typedef NS_ENUM(NSInteger, NLRewardAdPlaceCode) {
    NLRewardAdPlaceCodeSign = 4000,//签到
    NLRewardAdPlaceCodeBindPhone = 4001,//绑定手机号
    NLRewardAdPlaceCodeOpenBox = 4002,//开宝箱
    NLRewardAdPlaceCodeNovelDownload = 4003,//小说下载
    NLRewardAdPlaceCodeNovelPrivilege = 4004,//小说广告权益
    NLRewardAdPlaceCodeComicPrivilege = 4005,//漫画广告权益
};

typedef NS_ENUM(NSInteger, NLAdPlaceCode) {
    NLAdPlaceCodeUnknow = 0,
    
    // 原生广告
    NLAdPlaceCodeNativeSplash = NLNativeAdPlaceCodeSplash,//开屏
    NLAdPlaceCodeNativeNovelRead = NLNativeAdPlaceCodeNovelRead,//小说阅读
    NLAdPlaceCodeNativeComicRead = NLNativeAdPlaceCodeComicRead,//漫画阅读
    NLAdPlaceCodeNativeNovelBottom = NLNativeAdPlaceCodeNovelBottom,//小说底部
    NLAdPlaceCodeNativeComicBottom = NLNativeAdPlaceCodeComicBottom,//漫画底部
    
    // Banner广告
    // NLAdPlaceCodeBannerStoreRecomend = 2000,//书城推荐
    // NLAdPlaceCodeBannerStoreGirl = 2001,//书城女生
    // NLAdPlaceCodeBannerStoreBoy = 2002,//书城男生
    // NLAdPlaceCodeBannerStoreNewest = 2003,//书城最新
    // NLAdPlaceCodeBannerTabComic = 2004,//漫画tab
    // NLAdPlaceCodeBannerTabWelfare = 2005,//福利tab
    // NLAdPlaceCodeBannerTabMine = 2006,//我的tab
    
    // 插页广告
    // NLAdPlaceCodeInterstitial XXX

    // 激励广告
    NLAdPlaceCodeRewardSign = NLRewardAdPlaceCodeSign,//签到
    NLAdPlaceCodeRewardBindPhone = NLRewardAdPlaceCodeBindPhone,//绑定手机号
    NLAdPlaceCodeRewardOpenBox = NLRewardAdPlaceCodeOpenBox,//开宝箱
    NLAdPlaceCodeRewardNovelDownload = NLRewardAdPlaceCodeNovelDownload,//小说下载
    NLAdPlaceCodeRewardNovelPrivilege = NLRewardAdPlaceCodeNovelPrivilege,//小说广告权益
    NLAdPlaceCodeRewardComicPrivilege = NLRewardAdPlaceCodeComicPrivilege,//漫画广告权益
};

#endif /* NLAdDefines_h */
