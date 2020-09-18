//
//  NLAdAdapter.m
//  Novel
//
//  Created by Ke Jie on 2020/9/10.
//  Copyright © 2020 panling. All rights reserved.
//

#import "NLAdAdapter.h"
#import "NLAdModelProtocol.h"

#define kUseAdManager 1

static NSString * const kAdLockName = @"com.pailing.adapterLock";

@interface NLAdAdapter()

@property (nonatomic, strong) NSLock *adLock;

// 原生
@property (nonatomic, strong) NSMutableArray<NLAdPlatformModelProtocol> *splashList;
@property (nonatomic, strong) id<NLAdPlatformModelProtocol> currentSplash;

@property (nonatomic, strong) NSMutableArray<NLAdPlatformModelProtocol> *readNovelList;
@property (nonatomic, strong) id<NLAdPlatformModelProtocol> currentReadNovel;

@property (nonatomic, strong) NSMutableArray<NLAdPlatformModelProtocol> *readComicList;
@property (nonatomic, strong) id<NLAdPlatformModelProtocol> currentReadComic;

@property (nonatomic, strong) NSMutableArray<NLAdPlatformModelProtocol> *bannerNovelList;
@property (nonatomic, strong) id<NLAdPlatformModelProtocol> currentBannerNovel;

@property (nonatomic, strong) NSMutableArray<NLAdPlatformModelProtocol> *bannerComicList;
@property (nonatomic, strong) id<NLAdPlatformModelProtocol> currentBannerComic;

@property (nonatomic, strong) NSMutableArray<NLAdPlatformModelProtocol> *rewardSignList;
@property (nonatomic, strong) id<NLAdPlatformModelProtocol> currentRewardSign;

@property (nonatomic, strong) NSMutableArray<NLAdPlatformModelProtocol> *rewardBindPhoneList;
@property (nonatomic, strong) id<NLAdPlatformModelProtocol> currentRewardBindPhone;

@property (nonatomic, strong) NSMutableArray<NLAdPlatformModelProtocol> *rewardOpenBoxList;
@property (nonatomic, strong) id<NLAdPlatformModelProtocol> currentRewardOpenBox;

@property (nonatomic, strong) NSMutableArray<NLAdPlatformModelProtocol> *rewardDownloadNovelList;
@property (nonatomic, strong) id<NLAdPlatformModelProtocol> currentRewardDownloadNovel;

@property (nonatomic, strong) NSMutableArray<NLAdPlatformModelProtocol> *rewardNovelPrivilegeList;
@property (nonatomic, strong) id<NLAdPlatformModelProtocol> currentRewardNovelPrivilege;

@property (nonatomic, strong) NSMutableArray<NLAdPlatformModelProtocol> *rewardComicPrivilegeList;
@property (nonatomic, strong) id<NLAdPlatformModelProtocol> currentRewardComicPrivilege;

@end

@implementation NLAdAdapter

- (NSLock *)adLock {
    if (_adLock == nil) {
        _adLock = [[NSLock alloc] init];
        _adLock.name = kAdLockName;
    }
    return _adLock;
}

- (NSMutableArray<NLAdPlatformModelProtocol> *)splashList {
    if (_splashList == nil) {
        _splashList = [[NSMutableArray<NLAdPlatformModelProtocol> alloc] init];
    }
    return _splashList;
}

- (NSMutableArray<NLAdPlatformModelProtocol> *)readNovelList {
    if (_readNovelList == nil) {
        _readNovelList = [[NSMutableArray<NLAdPlatformModelProtocol> alloc] init];
    }
    return _readNovelList;
}

- (NSMutableArray<NLAdPlatformModelProtocol> *)readComicList {
    if (_readComicList == nil) {
        _readComicList = [[NSMutableArray<NLAdPlatformModelProtocol> alloc] init];
    }
    return _readComicList;
}

- (NSMutableArray<NLAdPlatformModelProtocol> *)bannerNovelList {
    if (_bannerNovelList == nil) {
        _bannerNovelList = [[NSMutableArray<NLAdPlatformModelProtocol> alloc] init];
    }
    return _bannerNovelList;
}

- (NSMutableArray<NLAdPlatformModelProtocol> *)bannerComicList {
    if (_bannerComicList == nil) {
        _bannerComicList = [[NSMutableArray<NLAdPlatformModelProtocol> alloc] init];
    }
    return _bannerComicList;
}

- (NSMutableArray<NLAdPlatformModelProtocol> *)rewardSignList {
    if (_rewardSignList == nil) {
        _rewardSignList = [[NSMutableArray<NLAdPlatformModelProtocol> alloc] init];
    }
    return _rewardSignList;
}

- (NSMutableArray<NLAdPlatformModelProtocol> *)rewardBindPhoneList {
    if (_rewardBindPhoneList == nil) {
        _rewardBindPhoneList = [[NSMutableArray<NLAdPlatformModelProtocol> alloc] init];
    }
    return _rewardBindPhoneList;
}

- (NSMutableArray<NLAdPlatformModelProtocol> *)rewardOpenBoxList {
    if (_rewardOpenBoxList == nil) {
        _rewardOpenBoxList = [[NSMutableArray<NLAdPlatformModelProtocol> alloc] init];
    }
    return _rewardOpenBoxList;
}

- (NSMutableArray<NLAdPlatformModelProtocol> *)rewardDownloadNovelList {
    if (_rewardDownloadNovelList == nil) {
        _rewardDownloadNovelList = [[NSMutableArray<NLAdPlatformModelProtocol> alloc] init];
    }
    return _rewardDownloadNovelList;
}

- (NSMutableArray<NLAdPlatformModelProtocol> *)rewardNovelPrivilegeList {
    if (_rewardNovelPrivilegeList == nil) {
        _rewardNovelPrivilegeList = [[NSMutableArray<NLAdPlatformModelProtocol> alloc] init];
    }
    return _rewardNovelPrivilegeList;
}

- (NSMutableArray<NLAdPlatformModelProtocol> *)rewardComicPrivilegeList {
    if (_rewardComicPrivilegeList == nil) {
        _rewardComicPrivilegeList = [[NSMutableArray<NLAdPlatformModelProtocol> alloc] init];
    }
    return _rewardComicPrivilegeList;
}

- (void)setupPlaceItems:(NSArray<NLAdPlaceModelProtocol> *)placeItems {
    [self.adLock lock];
    for (id<NLAdPlaceModelProtocol> model in placeItems) {
        // 原生
        if (model.adPlaceCode == NLAdPlaceCodeNativeSplash) {
            [self.splashList addObjectsFromArray:model.adPlatformList];
        } else if (model.adPlaceCode == NLAdPlaceCodeNativeNovelRead) {
            [self.readNovelList addObjectsFromArray:model.adPlatformList];
        } else if (model.adPlaceCode == NLAdPlaceCodeNativeComicRead) {
            [self.readComicList addObjectsFromArray:model.adPlatformList];
        } else if (model.adPlaceCode == NLAdPlaceCodeNativeNovelBottom) {
            [self.bannerNovelList addObjectsFromArray:model.adPlatformList];
        } else if (model.adPlaceCode == NLAdPlaceCodeNativeComicBottom) {
            [self.bannerComicList addObjectsFromArray:model.adPlatformList];
        }
        //激励
        else if (model.adPlaceCode == NLAdPlaceCodeRewardSign) {
            [self.rewardSignList addObjectsFromArray:model.adPlatformList];
        } else if (model.adPlaceCode == NLAdPlaceCodeRewardOpenBox) {
            [self.rewardOpenBoxList addObjectsFromArray:model.adPlatformList];
        } else if (model.adPlaceCode == NLAdPlaceCodeRewardBindPhone) {
            [self.rewardBindPhoneList addObjectsFromArray:model.adPlatformList];
        } else if (model.adPlaceCode == NLAdPlaceCodeRewardNovelDownload) {
            [self.rewardDownloadNovelList addObjectsFromArray:model.adPlatformList];
        } else if (model.adPlaceCode == NLAdPlaceCodeRewardNovelPrivilege) {
            [self.rewardNovelPrivilegeList addObjectsFromArray:model.adPlatformList];
        } else if (model.adPlaceCode == NLAdPlaceCodeRewardComicPrivilege) {
            [self.rewardComicPrivilegeList addObjectsFromArray:model.adPlatformList];
        }
    }
    
    // 原生
    self.currentSplash = self.splashList.firstObject;
    self.currentReadNovel = self.readNovelList.firstObject;
    self.currentReadComic = self.readComicList.firstObject;
    self.currentBannerNovel = self.bannerNovelList.firstObject;
    self.currentBannerComic = self.bannerComicList.firstObject;
    
    // 激励
    self.currentRewardSign = self.rewardSignList.firstObject;
    self.currentRewardOpenBox = self.rewardOpenBoxList.firstObject;
    self.currentRewardBindPhone = self.rewardBindPhoneList.firstObject;
    self.currentRewardDownloadNovel = self.rewardDownloadNovelList.firstObject;
    self.currentRewardNovelPrivilege = self.rewardNovelPrivilegeList.firstObject;
    self.currentRewardComicPrivilege = self.rewardComicPrivilegeList.firstObject;
    [self.adLock unlock];
}

- (nullable NSString *)placeIdWithCode:(NLAdPlaceCode)placeCode {
    NSString *placeId = nil;
    [self.adLock lock];
    // 原生
    if (placeCode == NLAdPlaceCodeNativeSplash) {
        placeId = self.currentSplash.platformAdId;
    } else if (placeCode == NLAdPlaceCodeNativeNovelRead) {
        placeId = self.currentReadNovel.platformAdId;
    } else if (placeCode == NLAdPlaceCodeNativeComicRead) {
        placeId = self.currentReadComic.platformAdId;
    } else if (placeCode == NLAdPlaceCodeNativeNovelBottom) {
        placeId = self.currentBannerNovel.platformAdId;
    } else if (placeCode == NLAdPlaceCodeNativeComicBottom) {
        placeId = self.currentBannerComic.platformAdId;
    }
    //激励
    else if (placeCode == NLAdPlaceCodeRewardSign) {
        placeId = self.currentRewardSign.platformAdId;
    } else if (placeCode == NLAdPlaceCodeRewardOpenBox) {
        placeId = self.currentRewardOpenBox.platformAdId;
    } else if (placeCode >= NLAdPlaceCodeRewardBindPhone) {
        placeId = self.currentRewardBindPhone.platformAdId;
    } else if (placeCode == NLAdPlaceCodeRewardNovelDownload) {
        placeId = self.currentRewardDownloadNovel.platformAdId;
    } else if (placeCode == NLAdPlaceCodeRewardNovelPrivilege) {
        placeId = self.currentRewardNovelPrivilege.platformAdId;
    } else if (placeCode == NLAdPlaceCodeRewardComicPrivilege) {
        placeId = self.currentRewardComicPrivilege.platformAdId;
    }
    [self.adLock unlock];
    
    return placeId;
}

- (NSInteger)platformWithCode:(NLAdPlaceCode)placeCode {
    NSInteger platform = 1; //默认Google
    [self.adLock lock];
    // 原生
    if (placeCode == NLAdPlaceCodeNativeSplash) {
        platform = self.currentSplash.platformType;
    } else if (placeCode == NLAdPlaceCodeNativeNovelRead) {
        platform = self.currentReadNovel.platformType;
    } else if (placeCode == NLAdPlaceCodeNativeComicRead) {
        platform = self.currentReadComic.platformType;
    } else if (placeCode == NLAdPlaceCodeNativeNovelBottom) {
        platform = self.currentBannerNovel.platformType;
    } else if (placeCode == NLAdPlaceCodeNativeComicBottom) {
        platform = self.currentBannerComic.platformType;
    }
    //激励
    else if (placeCode == NLAdPlaceCodeRewardSign) {
        platform = self.currentRewardSign.platformType;
    } else if (placeCode == NLAdPlaceCodeRewardOpenBox) {
        platform = self.currentRewardOpenBox.platformType;
    } else if (placeCode == NLAdPlaceCodeRewardBindPhone) {
        platform = self.currentRewardBindPhone.platformType;
    } else if (placeCode == NLAdPlaceCodeRewardNovelDownload) {
        platform = self.currentRewardDownloadNovel.platformType;
    } else if (placeCode == NLAdPlaceCodeRewardNovelPrivilege) {
        platform = self.currentRewardNovelPrivilege.platformType;
    } else if (placeCode == NLAdPlaceCodeRewardComicPrivilege) {
        platform = self.currentRewardComicPrivilege.platformType;
    }
    [self.adLock unlock];
    
    return platform;
}

- (void)switchToNextWithCode:(NLAdPlaceCode)placeCode {
    NSMutableArray<NLAdPlatformModelProtocol> *list = [self listOfCode:placeCode];
    id<NLAdPlatformModelProtocol> model = [self currentModelOfCode:placeCode];
    if (!list || !model || ![list containsObject:model]) { return; }
    NSInteger index = [list indexOfObject:model];
    if (index < list.count - 1) {
        index += 1;
    } else {
        index = 0;
    }
    model = [list objectAtIndex:index];
    [self resetCurrentModelWithCode:placeCode model:model];
}

- (nullable NSMutableArray<NLAdPlatformModelProtocol> *)listOfCode:(NLAdPlaceCode)placeCode {
    NSMutableArray<NLAdPlatformModelProtocol> *list = nil;
    [self.adLock lock];
    //原生
    if (placeCode == NLAdPlaceCodeNativeSplash) {
        list = self.splashList;
    } else if (placeCode == NLAdPlaceCodeNativeNovelRead) {
        list = self.readNovelList;
    } else if (placeCode == NLAdPlaceCodeNativeComicRead) {
        list = self.readComicList;
    } else if (placeCode == NLAdPlaceCodeNativeNovelBottom) {
        list = self.bannerNovelList;
    } else if (placeCode == NLAdPlaceCodeNativeComicBottom) {
        list = self.bannerComicList;
    }
    //激励
    else if (placeCode == NLAdPlaceCodeRewardSign) {
        list = self.rewardSignList;
    } else if (placeCode == NLAdPlaceCodeRewardOpenBox) {
        list = self.rewardOpenBoxList;
    } else if (placeCode >= NLAdPlaceCodeRewardBindPhone) {
        list = self.rewardBindPhoneList;
    } else if (placeCode == NLAdPlaceCodeRewardNovelDownload) {
        list = self.rewardDownloadNovelList;
    } else if (placeCode == NLAdPlaceCodeRewardNovelPrivilege) {
        list = self.rewardNovelPrivilegeList;
    } else if (placeCode == NLAdPlaceCodeRewardComicPrivilege) {
        list = self.rewardComicPrivilegeList;
    }
    [self.adLock unlock];
    
    return list;
}

- (nullable id<NLAdPlatformModelProtocol>)currentModelOfCode:(NLAdPlaceCode)placeCode {
    id<NLAdPlatformModelProtocol> model = nil;
    [self.adLock lock];
    //原生
    if (placeCode == NLAdPlaceCodeNativeSplash) {
        model = self.currentSplash;
    } else if (placeCode == NLAdPlaceCodeNativeNovelRead) {
        model = self.currentReadNovel;
    } else if (placeCode == NLAdPlaceCodeNativeComicRead) {
        model = self.currentReadComic;
    } else if (placeCode == NLAdPlaceCodeNativeNovelBottom) {
        model = self.currentBannerNovel;
    } else if (placeCode == NLAdPlaceCodeNativeComicBottom) {
        model = self.currentBannerComic;
    }
    //激励
    else if (placeCode == NLAdPlaceCodeRewardSign) {
        model = self.currentRewardSign;
    } else if (placeCode == NLAdPlaceCodeRewardOpenBox) {
        model = self.currentRewardOpenBox;
    } else if (placeCode >= NLAdPlaceCodeRewardBindPhone) {
        model = self.currentRewardBindPhone;
    } else if (placeCode == NLAdPlaceCodeRewardNovelDownload) {
        model = self.currentRewardDownloadNovel;
    } else if (placeCode == NLAdPlaceCodeRewardNovelPrivilege) {
        model = self.currentRewardNovelPrivilege;
    } else if (placeCode == NLAdPlaceCodeRewardComicPrivilege) {
        model = self.currentRewardComicPrivilege;
    }
    [self.adLock unlock];
    
    return model;
}

- (void)resetCurrentModelWithCode:(NLAdPlaceCode)placeCode model:(id<NLAdPlatformModelProtocol>)model {
    [self.adLock lock];
    //原生
    if (placeCode == NLAdPlaceCodeNativeSplash) {
         self.currentSplash = model;
    } else if (placeCode == NLAdPlaceCodeNativeNovelRead) {
         self.currentReadNovel = model;
    } else if (placeCode == NLAdPlaceCodeNativeComicRead) {
         self.currentReadComic = model;
    } else if (placeCode == NLAdPlaceCodeNativeNovelBottom) {
         self.currentBannerNovel = model;
    } else if (placeCode == NLAdPlaceCodeNativeComicBottom) {
         self.currentBannerComic = model;
    }
    //激励
    else if (placeCode == NLAdPlaceCodeRewardSign) {
        self.currentRewardSign = model;
    } else if (placeCode == NLAdPlaceCodeRewardOpenBox) {
        self.currentRewardOpenBox = model;
    } else if (placeCode >= NLAdPlaceCodeRewardBindPhone) {
        self.currentRewardBindPhone = model;
    } else if (placeCode == NLAdPlaceCodeRewardNovelDownload) {
        self.currentRewardDownloadNovel = model;
    } else if (placeCode == NLAdPlaceCodeRewardNovelPrivilege) {
        self.currentRewardNovelPrivilege = model;
    } else if (placeCode == NLAdPlaceCodeRewardComicPrivilege) {
        self.currentRewardComicPrivilege = model;
    }
    [self.adLock unlock];
}

@end
