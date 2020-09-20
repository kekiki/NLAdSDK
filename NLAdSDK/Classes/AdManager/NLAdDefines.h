//
//  NLAdDefines.h
//  Novel
//
//  Created by Ke Jie on 2020/9/13.
//  Copyright © 2020 panling. All rights reserved.
//

#ifndef NLAdDefines_h
#define NLAdDefines_h

/// 广告平台定义
typedef NS_ENUM(NSInteger, NLAdPlatform) {
    NLAdPlatformAdmob = 1,          //Google AdMob
    NLAdPlatformFacebook = 2,       //Facebook
};

/**
广告位代码定义
http://wiki.local/pages/viewpage.action?pageId=3803267
*/

// 阅读原生广告位代码
typedef NS_ENUM(NSInteger, NLReadAdPlaceCode) {
    NLReadAdPlaceCodeNovel = 1001,//小说阅读
    NLReadAdPlaceCodeComic = 1002,//漫画阅读
};

// 原生广告位代码
typedef NS_ENUM(NSInteger, NLNativeAdPlaceCode) {
    NLNativeAdPlaceCodeSplash = 1000,//开屏
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
    NLAdPlaceCodeNativeNovelRead = NLReadAdPlaceCodeNovel,//小说阅读
    NLAdPlaceCodeNativeComicRead = NLReadAdPlaceCodeComic,//漫画阅读
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
