//
//  SoapHelp.h
//  HttpRequest
//
//  Created by tiger on 15/4/12.
//  Copyright (c) 2015年 long. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)();
typedef void (^NetWorkBlock)(int netConnetState);
typedef void (^resultBlock)(id resultValue);



@protocol soapHelpDelegate <NSObject>

@optional

/**
 *  请求失败返回错误
 *
 *  @param info <#info description#>
 */
-(void)soapHelpObjectErrorInfo:(id)info;

/**
 *  无网络返回
 */
-(void)soapHelpObjectFailureInfo;


@end

@interface JDragonSoap : NSObject
@property(nonatomic,assign)id<soapHelpDelegate>delegate;
@property(copy,nonatomic) NetWorkBlock  netBlock;

#pragma mark---------------请求------------------
@property(nonatomic,strong) NSString *urlHost;
@property(nonatomic,strong) NSDictionary *parameter;


#pragma mark--------------- 上传-----------------
@property(nonatomic,strong) UIImage  *upImage;  // image
@property(nonatomic,strong) NSString  *fileName;  //iamge 名字
@property(nonatomic,strong) NSString  *upImgParameterName;  //参数名字
;  //参数名字

+(JDragonSoap*)shareInstance;



/**
 *   状态为0 无网络 状态为1 wifi  状态为2 2G 状态为3 3G 状态为4 4G
 *
 *  @param net 返回状态码
 */
+(void)netWorkStateReachability:(NetWorkBlock)net;


/**
 *  POST请求
 *
 *  @param result 返回请求值
 */
+(void)soapPostRequestWith:(resultBlock)result;

+(void)soapPostRequestWith:(resultBlock)result errorBlock:(ErrorCodeBlock)error;

/**
 *  GET请求
 *
 *  @param result 返回请求值
 */
+(void)soapGetRequestWith:(ReturnValueBlock)result;

+(void)soapGetRequestWith:(ReturnValueBlock)result errorBlock:(ErrorCodeBlock)error;

/**
 *  上传Image  必须传image fileName  upImgParameterName
 *
 *  @param resultBlock   返回结果
 *  @param progressBlock  上传进度
 */
+(void)soapHelpUpdateLoadImagewithResult:(resultBlock)resultBlock withUploadProgress:(void (^)(float progress))progressBlock;

@end

