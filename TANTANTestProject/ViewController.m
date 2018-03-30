//
//  ViewController.m
//  TANTANTestProject
//
//  Created by 衡松 on 2018/3/30.
//  Copyright © 2018年 衡松. All rights reserved.
//

#import "ViewController.h"
#import "TTFeedBackViewController.h"
#import "AppDelegate.h"
#import "HSRichTextView.h"
@interface ViewController ()<UITextViewDelegate>

@property(nonatomic,strong)HSRichTextView *linkTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *htmlString = @"欢迎使用探探, 在使用过程中有疑问请<a href=\"tantanapp://feedback\">反馈</a>";
    NSMutableAttributedString *attributeStr = [[self attributedStringWithHTMLString:htmlString] mutableCopy];
     [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:21] range:NSMakeRange(0,attributeStr.string.length)];
    self.linkTextView.attributedText = attributeStr ;
    self.linkTextView.linkBlock = ^(NSURL *url) {
        NSString *str = url.absoluteString;
        if([str containsString:@"feedback"]){
           TTFeedBackViewController *feed = [[TTFeedBackViewController alloc]init];
            AppDelegate *delegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate.window.rootViewController presentViewController:feed animated:YES completion:nil];
            
        }
    };
}

//将HTML字符串转化为NSAttributedString富文本字符串
- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding)};
    NSData *data = [htmlString  dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}


- (HSRichTextView *)linkTextView
{
    if (!_linkTextView) {
        _linkTextView = [[HSRichTextView alloc] init];
        _linkTextView.backgroundColor = [UIColor greenColor];
         _linkTextView.frame = CGRectMake(50,100,300,80);
        [self.view addSubview:_linkTextView];
        
    }
    return _linkTextView;
}



@end
