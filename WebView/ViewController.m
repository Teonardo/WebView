//
//  ViewController.m
//  WebView
//
//  Created by Teonardo on 2019/12/11.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"webPage" ofType:@"txt"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:(NSUTF8StringEncoding) error:nil];
    [self.webView loadHTMLString:[self htmlEntityDecode:str] baseURL:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
        [self setWebViewHtmlImageFitPhone];
}

#pragma mark - Private Method

/**
 HTML 标签标准化 (将 &lt 等类似的字符转化为HTML中的“<”等)
 用WebView 加载 HTML 字符串时, 拿到的字符串可能不是标准的标签的HTML字符串, 需要将字符串转换成标准的HTML字符串
 
 @param string 原字符串
 @return 转化后标准的HTML字符串
 */
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

- (void)setWebViewHtmlImageFitPhone
{
    // 适配后的图片宽度
    CGFloat width = [[UIScreen mainScreen]bounds].size.width - 16;
    
    NSString *jsStr = [NSString stringWithFormat:@"var script = document.createElement('script');"
                       "script.type = 'text/javascript';"
                       "script.text = \"function ResizeImages() { "
                       "var myimg,oldwidth,oldHeight;"
                       "var fitWidth = '%f';" //自定义宽度
                       "for(i=0;i <document.images.length;i++){"
                       "myimg = document.images[i];"
                       "if(myimg.width != fitWidth){"
                       "oldwidth = myimg.width;"
                       "oldHeight = myimg.height;"
                       "myimg.width = fitWidth;"
                       "myimg.height = oldHeight * fitWidth / oldwidth;"
                       "}"
                       "}"
                       "}\";"
                       "document.getElementsByTagName('head')[0].appendChild(script);",width];
    
    [_webView stringByEvaluatingJavaScriptFromString:jsStr];
    [_webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}

#pragma mark - Getter

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        //_webView.scalesPageToFit = YES;
        _webView.delegate = self;
    }
    return _webView;
}

@end
