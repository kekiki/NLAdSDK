//
//  UILabel+TextSpace.m
//  Touch 'n Go
//
//  Created by Allen on 2018/8/18.
//  Copyright © 2018年 orangenat. All rights reserved.
//

#import "UILabel+TextSpace.h"

@implementation UILabel (TextSpace)

- (NSMutableAttributedString *)setLineSpace:(float)space {
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    paragraphStyle.alignment = self.textAlignment;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
    return attributedString;
}

- (void)setWordSpace:(float)space {
    
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

- (void)setLineSpace:(float)lineSpace wordSpace:(float)wordSpace {
    
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    paragraphStyle.alignment = self.textAlignment;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

- (NSMutableDictionary *)setLineHeight:(float)lineHeight {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.minimumLineHeight = lineHeight;

    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:self.font forKey:NSFontAttributeName];
    [attributes setObject:self.textColor forKey:NSForegroundColorAttributeName];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [attributes setObject:@((lineHeight - self.font.lineHeight) / 4) forKey:NSBaselineOffsetAttributeName];
   NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    self.attributedText = attributedText;
    [self sizeToFit];
    return attributes;
}

- (NSMutableDictionary *)setLineHeight:(float)lineHeight wordSpace:(float)wordSpace {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.minimumLineHeight = lineHeight;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:self.font forKey:NSFontAttributeName];
    [attributes setObject:self.textColor forKey:NSForegroundColorAttributeName];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [attributes setObject:@(wordSpace) forKey:NSKernAttributeName];
    [attributes setObject:@((lineHeight - self.font.lineHeight) / 4) forKey:NSBaselineOffsetAttributeName];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    self.attributedText = attributedText;
    [self sizeToFit];
    return attributes;
}

@end
