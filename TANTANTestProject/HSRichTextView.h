//
//  HSRichTextView.h
//  TANTANTestProject
//
//  Created by 衡松 on 2018/3/30.
//  Copyright © 2018年 衡松. All rights reserved.
//
/*  用textview点击区域不准，uiwebview消耗内存 用了些时间实现了个简单的富文本  */
#import <UIKit/UIKit.h>

@interface HSRichTextView : UIView
@property (nonatomic, copy) NSAttributedString *attributedText;

// 超链接回调
@property (nonatomic, copy) void (^linkBlock)(NSURL *url);
@end
