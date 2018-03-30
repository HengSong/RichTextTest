//
//  HSRichTextView.m
//  TANTANTestProject
//
//  Created by 衡松 on 2018/3/30.
//  Copyright © 2018年 衡松. All rights reserved.
//
/*  用textview点击区域不准，uiwebview消耗内存 用了些时间实现了个简单的富文本  */
#import "HSRichTextView.h"


@interface HSRichTextView()
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;
// 超链接的<rangString:value>
@property (nonatomic, strong) NSMutableDictionary *linksDict;
@end
@implementation HSRichTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.textStorage addLayoutManager:self.layoutManager];
        [self.layoutManager addTextContainer:self.textContainer];
        self.layoutManager.allowsNonContiguousLayout = NO;
        self.textContainer.lineFragmentPadding = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textContainer.size = self.bounds.size;
    [self.layoutManager textContainerChangedGeometry:self.textContainer];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    NSAttributedString *contentString = [self dealLinkWithAttributedString:attributedText];
    _attributedText = contentString;
    [self.textStorage setAttributedString:contentString];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSRange range = NSMakeRange(0, self.textStorage.length);
    [self.layoutManager drawBackgroundForGlyphRange:range atPoint:CGPointZero];
    [self.layoutManager drawGlyphsForGlyphRange:range atPoint:CGPointZero];
}

- (NSAttributedString *)dealLinkWithAttributedString:(NSAttributedString *)attributedString
{
    NSMutableAttributedString *tempString = [attributedString mutableCopy];
    __weak typeof(self) weakSelf = self;
    [attributedString enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id value, NSRange range, BOOL *stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (value) {
            [tempString removeAttribute:NSLinkAttributeName range:range];
            NSString *rangeString = NSStringFromRange(range);
            [strongSelf.linksDict setValue:value forKey:rangeString];
        }
    }];
    return tempString;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.linksDict.count) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];
    
    NSUInteger index = [self.layoutManager glyphIndexForPoint:location inTextContainer:self.textContainer];
    id value = nil;
    BOOL swallowTouch = NO;
    for (NSString *rangeString in self.linksDict) {
        NSRange range = NSRangeFromString(rangeString);
        BOOL flag = NSLocationInRange(index, range);
        if (flag) {
            swallowTouch = YES;
            value = [self.linksDict objectForKey:rangeString];
            break;
        }
    }
    
    if (swallowTouch) {
        if (self.linkBlock) {
            self.linkBlock(value);
        }
    }else {
        [super touchesEnded:touches withEvent:event];
    }
}

#pragma mark - getter/setter
- (NSTextStorage *)textStorage
{
    if (!_textStorage) {
        _textStorage = [[NSTextStorage alloc] init];
    }
    return _textStorage;
}

- (NSLayoutManager *)layoutManager
{
    if (!_layoutManager) {
        _layoutManager = [[NSLayoutManager alloc] init];
    }
    return _layoutManager;
}

- (NSTextContainer *)textContainer
{
    if (!_textContainer) {
        _textContainer = [[NSTextContainer alloc] init];
    }
    return _textContainer;
}

- (NSMutableDictionary *)linksDict
{
    if (!_linksDict) {
        _linksDict = [NSMutableDictionary dictionary];
    }
    return _linksDict;
}


@end
