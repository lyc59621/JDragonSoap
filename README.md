# JDragonSoap
一个基于AFNetworking的网络请求

![badge-pod] ![badge-languages] ![badge-platforms] ![badge-mit]



# 更新日志：基于AFNetworking 3.1  

NSURLConnection 替换为NSURLSession 

##setup

### user pod

```

pod 'JDragonSoap','~> 0.0.7'


```


## 如何使用


```
[JDragonSoap shareInstance].urlHost =@"";
[JDragonSoap shareInstance].parameter = @{};



/**
*  检测网络状态
*/
[JDragonSoap netWorkStateReachability:^(int netConnetState) {

NSLog(@"网络状态==%d",netConnetState);
}];


/**
*  Get 请求
*
*  @param returnValue block
*
*  @return 数据请求结果
*/
[JDragonSoap soapGetRequestWith:^(id returnValue) {

NSLog(@"Get=======%@",returnValue);

}];

[JDragonSoap soapGetRequestWith:^(id returnValue) {

[SVProgressHUD dismiss];
NSLog(@"get=======%@",returnValue);

} errorBlock:^(id errorCode) {

NSLog(@"error=======%@",errorCode);

}];




```



```
[JDragonSoap shareInstance].urlHost =@"";
[JDragonSoap shareInstance].parameter = @{};

/**
*  Post 请求
*
*  @param returnValue block
*
*  @return 数据请求结果
*/
[JDragonSoap soapPostRequestWith:^(id resultValue) {

NSLog(@"Post=======%@",resultValue);

}];

[JDragonSoap soapPostRequestWith:^(id resultValue) {

[SVProgressHUD  dismiss];
NSLog(@"post=======%@",resultValue);

} errorBlock:^(id errorCode) {

NSLog(@"error=======%@",errorCode);

}];


```


## other

详细请看demo



[badge-platforms]: https://img.shields.io/badge/platforms-iOS-lightgrey.svg
[badge-pod]: https://img.shields.io/cocoapods/v/JDragonSoap.svg?label=version
[badge-languages]: https://img.shields.io/badge/languages-ObjC-orange.svg
[badge-mit]: https://img.shields.io/badge/license-MIT-blue.svg



