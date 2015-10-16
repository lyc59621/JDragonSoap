//
//  ViewController.m
//  JDragonSoapDemo
//
//  Created by JDragon on 15/10/16.
//  Copyright © 2015年 JDragon. All rights reserved.
//

#import "ViewController.h"
#import "HttpHeader.h"
@interface ViewController ()<soapHelpDelegate>
@property(nonatomic,strong)SoapHelp  *soap;

@end

@implementation ViewController
@synthesize soap;
- (void)viewDidLoad {
    [super viewDidLoad];
    soap = [SoapHelp shareInstance];
    soap.delegate =self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)GetDidClickButtonAction:(UIButton *)sender {
    
#pragma mark----------设置请求url-------------------
    
    /**
     *  不建议使用这种方式
     */
    //    soap.urlHost = @"http://218.200.160.29/rdp2/test/v5.5/firstlist.do?groupcode=365911/365949&&ua=Iphone_Sst&&version=4.2000";
    
#pragma mark-------可以使用下面方式传入参数-------------------
    /**
     *  使用规范模式
     */
    soap.urlHost =@"http://218.200.160.29/rdp2/test/v5.5/firstlist.do?";
    soap.parameter = @{@"groupcode":@"365911/365949",@"ua":@"Iphone_Sst",@"version":@"4.2000"};
    
    [ SVProgressHUD   showWithStatus:@"请求中" maskType:SVProgressHUDMaskTypeBlack ];
    [SoapHelp soapGetRequestWith:^(id returnValue) {
        
        [SVProgressHUD dismiss];
        NSLog(@"get=======%@",returnValue);
    }];
    

    
    
    
}
- (IBAction)PostDidClickButtonAction:(UIButton *)sender {
    
    
    soap.urlHost = @"https://account.cimyun.com/users/login";
    soap.parameter = @{@"phone":@"15104442573",@"password":@"123456"
                       };
    [ SVProgressHUD   showWithStatus:@"请求中" maskType:SVProgressHUDMaskTypeGradient ];
    
    [SoapHelp soapPostRequestWith:^(id resultValue) {
        [SVProgressHUD  dismiss];
        NSLog(@"post=======%@",resultValue);
    }];
 
    
    
}



- (IBAction)netTypeButtonAction:(UIButton *)sender {
    
    
    [SoapHelp   netWorkStateReachability:^(int netConnetState) {
        
        NSLog(@"网络状态为%d",netConnetState);
        
    }];
    
    
    
}


/**
 *  请求错误
 */
-(void)soapHelpObjectErrorInfo:(id)info
{
    [SVProgressHUD dismiss];
    NSLog(@"错误信息为%@",info);
    
    
}

/**
 *  无网络返回
 */
-(void)soapHelpObjectFailureInfo
{
    [SVProgressHUD dismiss];
    
    NSLog(@"无网络");
    
    
}


@end
