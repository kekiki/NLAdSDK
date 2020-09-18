//
//  UITextField+DC.h
//  jdApp
//
//  Created by SquRab on 2019/4/1.
//  Copyright © 2019 squrab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IBTextFieldLengthChangeBlock)(NSInteger currentLength);

IB_DESIGNABLE

@interface UITextField (DC)
/**
 设置最大长度
 */
@property (nonatomic, assign) IBInspectable NSInteger maxLength;
@property (nonatomic, assign) IBInspectable NSInteger minLength;

/**
 *  当前已输入文本的长度 中文未输入完成(料想的 有高亮的)的文本不计入已输入的长度
 *  表情符号eg 😄长度仅记为1 计算方式为NSStringEnumerationByComposedCharacterSequences
 */
@property (nonatomic, assign) NSInteger ib_currentLength;

/**
 *  剩余可输入文本的长度
 */
- (NSInteger)ib_getRemainTextLength;

/**
 *  文本长度是否在设置的范围内
 */
- (BOOL)ib_isTextValide;

/**
 *  监听文本长度变化
 *
 *  @param length 当前text length
 */
- (void)ib_observerTextLengthChanged:(IBTextFieldLengthChangeBlock)length;

- (void)addLeftSpace:(CGFloat)space;
- (void)addRightSpace:(CGFloat)space;

@end
