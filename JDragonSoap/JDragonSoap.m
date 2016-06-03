//
//  SoapHelp.m
//  HttpRequest
//
//  Created by tiger on 15/4/12.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "JDragonSoap.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Reachability.h"

@interface JDragonSoap ()

@property (strong, nonatomic) ReturnValueBlock returnBlock;
@property (strong, nonatomic) ErrorCodeBlock errorBlock;
@property (strong, nonatomic) FailureBlock failureBlock;

@property(nonatomic,strong) Reachability  *reachability;

//获取网络的链接状态
-(void) netWorkStateWithNetConnectBlock: (NetWorkBlock) netConnectBlock WithURlStr: (NSString *) strURl;

// 传入交互的Block块
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
               WithFailureBlock: (FailureBlock) failureBlock;

@end

@implementation JDragonSoap

//-(id)init
//{
//    
//    if (self=[super init]) {
//        self.info = self;
//        [self checkReachability];
//    }
//    return self;
//}

+(JDragonSoap*)shareInstance
{
    static JDragonSoap *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedInstance = [[JDragonSoap alloc] init];
        [_sharedInstance checkReachability];
    });
    
    return _sharedInstance;
}

#pragma 获取网络可到达状态
-(void) netWorkStateWithNetConnectBlock: (NetWorkBlock) netConnectBlock WithURlStr: (NSString *) strURl;
{
    _netBlock = netConnectBlock;
}

#pragma 接收穿过来的block
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
               WithFailureBlock: (FailureBlock) failureBlock
{
    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
    _failureBlock = failureBlock;
}
+(void)soapPostRequestWith:(resultBlock)result{
    
    [JDragonSoap NetRequestPOSTWithRequestURL: [JDragonSoap shareInstance].urlHost WithParameter:[JDragonSoap shareInstance].parameter WithReturnValeuBlock:^(id returnValue) {
        result(returnValue);
    } WithErrorCodeBlock:^(id errorCode) {
        
        [JDragonSoap shareInstance].errorBlock(errorCode);
    } WithFailureBlock:^{
        
       [JDragonSoap shareInstance].failureBlock();
    }];

    [[JDragonSoap shareInstance] soapHelpRequestResultInfo];
    
}
-(void)soapHelpRequestResultInfo
{
    
    __weak    JDragonSoap  *soap = self;
    
   [self setBlockWithReturnBlock:^(id returnValue) {
       
//       if ([soap.delegate respondsToSelector:@selector(soapHelpObjectResultInfo:)]) {
//           
//           [soap.delegate  soapHelpObjectResultInfo:returnValue];
//       }
//       NSLog(@"rereer%@",returnValue);
       soap.returnBlock(returnValue);
       
   } WithErrorBlock:^(id errorCode) {
       
       if ([soap.delegate respondsToSelector:@selector(soapHelpObjectErrorInfo:)]) {
           
           [soap.delegate  soapHelpObjectErrorInfo:errorCode];
       }
       
   } WithFailureBlock:^{
       
       if ([soap.delegate respondsToSelector:@selector(soapHelpObjectFailureInfo)]) {
           
           [soap.delegate  soapHelpObjectFailureInfo];
       }
       
   }];
    
}
+(void)soapGetRequestWith:(ReturnValueBlock)result
{
    [JDragonSoap NetRequestGETWithRequestURL: [JDragonSoap shareInstance].urlHost WithParameter:[JDragonSoap shareInstance].parameter WithReturnValeuBlock:^(id returnValue) {
//        _returnBlock(returnValue);
        result(returnValue);
    } WithErrorCodeBlock:^(id errorCode) {
        
        [JDragonSoap shareInstance].errorBlock(errorCode);
    } WithFailureBlock:^{
        
        [JDragonSoap shareInstance].failureBlock();
//        LLog(@"网络异常");
    }];
    [JDragonSoap shareInstance].returnBlock = result;
    [[JDragonSoap shareInstance] soapHelpRequestResultInfo];
   
}

+(void)netWorkStateReachability:(NetWorkBlock)net
{
//    [SoapHelp netWorkReachabilityWithURLString:@"wap.baidu.com" withReturnNetBlock:^(int netConnetState) {
//                  [SoapHelp shareInstance].netBlock(netConnetState);
//            }];
   [JDragonSoap shareInstance].netBlock = net;
   [[JDragonSoap shareInstance] updateInterfaceWithReachability:[JDragonSoap shareInstance].reachability];
}


#pragma mark Reachability Methods
#pragma mark
- (void)checkReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    [self updateInterfaceWithReachability:self.reachability];
    
 }

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability * curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    int  net = 0;
    if(status == NotReachable)
    {
        //No internet
        NSLog(@"No Internet");
        net = 0;
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        NSLog(@"Reachable WIFI");
        net = 1;
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        NSLog(@"Reachable 3G");
        net=  [JDragonSoap checkNetWorklocalType];
    }
    if (_netBlock) {
        [JDragonSoap shareInstance].netBlock(net);
    }
}
#pragma mark-----------------------------------
#pragma 监测网络的可链接性
+(void) netWorkReachabilityWithURLString:(NSString *) strUrl withReturnNetBlock:(NetWorkBlock)netBlock;
{

    __block int  netState;
    
    NSURL *baseURL = [NSURL URLWithString:strUrl];
    
    AFHTTPSessionManager  *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:baseURL];
  
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                
                netState = [JDragonSoap checkNetWorklocalType];
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = 0;
            default:
                [operationQueue setSuspended:YES];
                break;
        }
        netBlock(netState);
    }];
    
    [manager.reachabilityManager startMonitoring];
    
}
/**
 *  判断网络
 *
 *  @return 返回网络状态
 */
+(int)checkNetWorklocalType
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    int state = 0;
    int netType ;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
//                    state = @"无网络";
                     state = 0;
                    //无网模式
                    break;
                case 1:
//                    state = @"2G";
                    state =2;

                    break;
                case 2:
//                    state = @"3G";
                     state = 3;
                    break;
                case 3:
//                    state = @"4G";
                    state = 4;
                    break;
                case 5:
                {
//                    state = @"WIFI";
                    state = 1;
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}


/*
 在这做判断如果有dic里有errorCode
 调用errorBlock(dic)
 没有errorCode则调用block(dic
 */
#pragma --mark GET请求方式
+ (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock
{
    
    AFHTTPSessionManager  *manager = [AFHTTPSessionManager manager];

    
    NSURLSessionTask  *task = [manager GET:requestURLString parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  responseObject) {
              NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:(NSData*)responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        block(dic);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            errorBlock(error);

    }];
    
   manager.responseSerializer  = [AFHTTPResponseSerializer serializer];
    
    
}
#pragma --mark POST请求方式
+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock
{

    AFHTTPSessionManager  *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer.timeoutInterval = 120;

    NSURLSessionTask  *task = [manager POST:requestURLString parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //        LLog(@"%@", dic);
        
        block(dic);
        /*
         在这做判断如果有dic里有errorCode
         调用errorBlock(dic)
         没有errorCode则调用block(dic
         */
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
       
        errorBlock(error);

    }];
    manager.responseSerializer  = [AFHTTPResponseSerializer serializer];

    
}

+(void)soapHelpUpdateLoadImagewithResult:(resultBlock)resultBlock withUploadProgress:(void (^)(float progress))progressBlock;
{
    
   AFHTTPSessionManager  *manager = [AFHTTPSessionManager manager];
    
    NSURLSessionDataTask  *task = [manager POST:[JDragonSoap shareInstance].urlHost parameters:[JDragonSoap shareInstance].parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    NSData *imageData = UIImageJPEGRepresentation([JDragonSoap shareInstance].upImage, 0.3);
    [formData appendPartWithFileData:imageData name:[JDragonSoap shareInstance].upImgParameterName fileName:[JDragonSoap shareInstance].fileName mimeType:@"image/jpeg/file"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度＝＝%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        resultBlock(dic);
      //        NSLog(@"成功%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [JDragonSoap shareInstance].errorBlock(error);
    }];
    
    
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSURL *URL = [NSURL URLWithString:[JDragonSoap shareInstance].urlHost];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSData *imageData = UIImageJPEGRepresentation([JDragonSoap shareInstance].upImage, 0.3);
//    
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:imageData progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//
//        
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSLog(@"%@ %@", response, responseObject);
//        }
//        
//    }];
//    NSProgress  *gress = [manager  uploadProgressForTask:uploadTask ];
//    
//    NSLog(@"上传进度＝＝%@",gress);
    

    
}

@end
