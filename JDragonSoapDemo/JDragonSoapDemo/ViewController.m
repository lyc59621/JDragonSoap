//
//  ViewController.m
//  JDragonSoapDemo
//
//  Created by JDragon on 15/10/16.
//  Copyright © 2015年 JDragon. All rights reserved.
//

#import "ViewController.h"
#import "JDragonSoap.h"
#import "SVProgressHUD.h"
@interface ViewController ()<soapHelpDelegate>
@property(nonatomic,strong)JDragonSoap  *soap;

@end

@implementation ViewController
@synthesize soap;
- (void)viewDidLoad {
    [super viewDidLoad];
    soap = [JDragonSoap shareInstance];
    soap.delegate =self;
    // Do any additional setup after loading the view, typically from a nib.
    
    
    /**
     *  检测网络状态
     */
    [JDragonSoap netWorkStateReachability:^(int netConnetState) {
       
        NSLog(@"网络状态==%d",netConnetState);
    }];
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
    //    soap.urlHost = @"http://232323233/tv5tlist.do?groupcode=3651/3&&ua=Iphonet&&versio=4.0";
    
#pragma mark-------可以使用下面方式传入参数-------------------
    /**
     *  使用规范模式
     */
    soap.urlHost =@"http://wewewe";//请自行替换
    soap.parameter = @{@"grouode":@"36",@"ua":@"_Sst",@"versn":@"4.00"};
    
    [ SVProgressHUD   showWithStatus:@"请求中" maskType:SVProgressHUDMaskTypeBlack ];
    
    /**
     *  Get 请求
     *
     *  @param returnValue block
     *
     *  @return 请求结果
     */
    [JDragonSoap soapGetRequestWith:^(id returnValue) {
        
        [SVProgressHUD dismiss];
        NSLog(@"get=======%@",returnValue);
    }];
    
    [JDragonSoap soapGetRequestWith:^(id returnValue) {
        
        [SVProgressHUD dismiss];
        NSLog(@"get=======%@",returnValue);
    } errorBlock:^(id errorCode) {
        
        NSLog(@"error=======%@",errorCode);
    }];
    
}
- (IBAction)PostDidClickButtonAction:(UIButton *)sender {
    
    
    soap.urlHost = @"https://232323"; //请自行替换
    soap.parameter = @{@"phone":@"123232",@"password":@"123456"
                       };
    [ SVProgressHUD   showWithStatus:@"请求中" maskType:SVProgressHUDMaskTypeGradient ];
    
    /**
     *  Post 请求
     *
     *  @param returnValue block
     *
     *  @return 请求结果
     */

     [JDragonSoap soapPostRequestWith:^(id resultValue) {
        [SVProgressHUD  dismiss];
        NSLog(@"post=======%@",resultValue);
     } errorBlock:^(id errorCode) {
         NSLog(@"error=======%@",errorCode);
     }];
}
- (IBAction)netTypeButtonAction:(UIButton *)sender {
    
    
    [JDragonSoap   netWorkStateReachability:^(int netConnetState) {
        
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
