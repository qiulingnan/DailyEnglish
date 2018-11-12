//
//  HWBaseWebViewController.m
//  WebView封装
//
//  Created by Hanwen on 2017/12/28.
//  Copyright © 2017年 SK丿希望. All rights reserved.
//

#import "HWBaseWebViewController.h"
#import <WebKit/WebKit.h>

@interface HWBaseWebViewController ()<WKNavigationDelegate>
/** <#注释#> */
@property(nonatomic, strong) WKWebView *webView;
/** <#注释#> */
@property(nonatomic, strong) UIView *mainView;
/** <#注释#> */
@property(nonatomic, strong) UIProgressView *progressView;
@end

@implementation HWBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMainView];
    [self creatWebView];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 添加进度条
- (void)addMainView {
    HWWeakSelf(weakSelf)
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HWScreenW, HWScreenH)];
    mainView.backgroundColor = [UIColor clearColor];
    _mainView = mainView;
    [weakSelf.view addSubview:mainView];
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, HWScreenW, 1)];
    progressView.progress = 0;
    _progressView = progressView;
    [weakSelf.view addSubview:progressView];
}
- (void)creatWebView {
    HWWeakSelf(weakSelf)
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, HWScreenW, HWScreenH)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.navigationDelegate = weakSelf;
    _webView.scrollView.bounces = NO;
    [weakSelf.mainView addSubview:_webView];
    // 添加观察者
    [_webView addObserver:weakSelf forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL]; // 进度
    [_webView addObserver:weakSelf forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL]; // 标题
}
- (void)setUrl:(NSURL *)url {
    _url = url;
    HWWeakSelf(weakSelf)
    NSURLRequest *request = [NSURLRequest requestWithURL:weakSelf.url];
    [_webView loadRequest:request];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}
// 页面加载完毕时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
}
#pragma mark - 监听加载进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    HWWeakSelf(weakSelf)
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == _webView) {
            [weakSelf.progressView setAlpha:1.0f];
            [weakSelf.progressView setProgress:weakSelf.webView.estimatedProgress animated:YES];
            if(weakSelf.webView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [weakSelf.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [weakSelf.progressView setProgress:0.0f animated:NO];
                }];
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }  else if ([keyPath isEqualToString:@"title"]) {
        HWLog(@"%@",weakSelf.webView.title);
        if (object == weakSelf.webView) {
            weakSelf.title = weakSelf.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
// 当对象即将销毁的时候调用
- (void)dealloc {
    NSLog(@"webView释放");
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
    _webView.navigationDelegate = nil;
}
#pragma mark - WKNavigationDelegate
#pragma mark - 截取当前加载的URL
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    HWWeakSelf(weakSelf)
//    NSURL *URL = navigationAction.request.URL;
//    HWLog(@"%@", URL);
//    if (![[NSString stringWithFormat:@"%@", weakSelf.url] isEqualToString:[NSString stringWithFormat:@"%@", URL]]) { // 不相等
//        //        weakSelf.navigationView.titleLabel.text = @"攻略详情";
//        HWStrategyDetailsViewController *vc = [[HWStrategyDetailsViewController alloc] init];
//        vc.url = URL;
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//        //        self.button.hidden = NO;
//        //        _webView.height = HWScreenH-64-50;
//        //        self.collectionButton.hidden = NO;
//        //        self.forwardingButton.hidden = NO;
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else {
//        weakSelf.navigationView.titleLabel.text = weakSelf.title;
//        decisionHandler(WKNavigationActionPolicyAllow); // 必须实现 不然会崩溃
//    }
//}
@end
