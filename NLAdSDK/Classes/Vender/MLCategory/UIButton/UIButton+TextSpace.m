//
//  UIButton+TextSpace.m
//  Touch 'n Go
//
//  Created by Allen on 2018/8/18.
//  Copyright © 2018年 orangenat. All rights reserved.
//

#import "UIButton+TextSpace.h"

@implementation UIButton (TextSpace)

- (void)setWordSpace:(float)space forState:(UIControlState)state {
    NSString *labelText = [self titleForState:state];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.titleLabel.textAlignment;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    [self setAttributedTitle:attributedString forState:state];
}

- (void)setLineHeight:(float)lineHeight forState:(UIControlState)state {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = self.titleLabel.textAlignment;
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.minimumLineHeight = lineHeight;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:self.titleLabel.font forKey:NSFontAttributeName];
    [attributes setObject:[self titleColorForState:state] forKey:NSForegroundColorAttributeName];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [attributes setObject:@((lineHeight - self.titleLabel.font.lineHeight) / 4) forKey:NSBaselineOffsetAttributeName];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.currentTitle attributes:attributes];
    [self setAttributedTitle:attributedText forState:state];
    [self sizeToFit];
}

- (void)setLineHeight:(float)lineHeight wordSpace:(float)wordSpace forState:(UIControlState)state {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = self.titleLabel.textAlignment;
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.minimumLineHeight = lineHeight;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:self.titleLabel.font forKey:NSFontAttributeName];
    [attributes setObject:[self titleColorForState:state] forKey:NSForegroundColorAttributeName];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [attributes setObject:@(wordSpace) forKey:NSKernAttributeName];
    [attributes setObject:@((lineHeight - self.titleLabel.font.lineHeight) / 4) forKey:NSBaselineOffsetAttributeName];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.currentTitle attributes:attributes];
    [self setAttributedTitle:attributedText forState:state];
    [self sizeToFit];
}

@end
