//
//  MLUtils.h
//  Novel
//
//  Created by Allen on 2020/5/19.
//  Copyright © 2020 panling. All rights reserved.
//

#ifndef MLUtils_h
#define MLUtils_h

#import "NSString+Exist.h"
#import "UIButton+ClickRange.h"
#import "UIButton+TextSpace.h"
#import "UILabel+TextSpace.h"
#import "UILabel+TextSize.h"
#import "UIButton+TextSpace.h"
#import "UITextField+DC.h"
#import "UIView+CR.h"
#import "UIView+CBBlock.h"
#import "UIView+Gradient.h"
#import "UIView+screenshot.h"
#import "UIViewController+CBBlock.h"

/**
 * 返回非nil String
 * 如果是nil，返回@""，用于加数组，字典防止崩溃或防止界面显示null
 */
#define NoNullStr(str) (str ? str : @"")

/** * 返回cellID标记（cell类名后加ID */
#define CellID(cellClass) [NSString stringWithFormat:@"%@ID", NSStringFromClass([cellClass class])]

/** * 返回类名nib */
#define NibObj(aClass) [UINib nibWithNibName:NSStringFromClass([aClass class]) bundle:nil]

/** * 返回class类实例 */
#define Cls(cls) [NSClassFromString(cls) new]

/** * 返回类名字符串 */
#define ClassString(aClass) NSStringFromClass([aClass class]

/**
 *  URL
 */
#define URL(urlString) [NSURL URLWithString:urlString]

/* *********** UIColor ************ */
#define UIColorHexStr(s) [UIColor colorWithHexString:s]
#define ClearColor [UIColor clearColor]
//#define WhiteColor [UIColor whiteColor]
#define BlackColor [UIColor blackColor]

//APP版本号：
#define APP_Version    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_Name       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

/* *********** UIImage ************ */
#define ImageNamed(img) [UIImage imageNamed:img]
#define ImageWithName(nameStr)  [UIImage imageNamed:nameStr]
#define ImageRawNamed(image)    [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  // 原始图片,未渲染的图片
#define ImageFile(A)            [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

/** * 主窗口 */
#define AppKeyWindow [UIApplication sharedApplication].keyWindow

/** * 是否是字典 */
#define isDict(data) [data isKindOfClass:[NSDictionary class]]

/** * 是否是字符串 */
#define isString(data) [data isKindOfClass:[NSString class]]

/** * 转换数字为字符串 */
#define NumberString(number) [@(number) stringValue]

/**
 * NSUserDefaults单例
 */
#define kUserDefaults [NSUserDefaults standardUserDefaults]

#define kNotificationCenter [NSNotificationCenter defaultCenter]

/**
 * 生成 weak && strong 对象,成对使用
 */
#define Weakify(obj)   __weak   __typeof(&*obj) weak##obj = obj;
#define Strongify(obj) __strong __typeof(&*obj) obj = weak##obj;

#define WeakSelfMake   Weakify(self)
#define StrongSelfMake Strongify(self)

/**
 * 检测block是否可用
 */
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

#endif /* MLUtils_h */
