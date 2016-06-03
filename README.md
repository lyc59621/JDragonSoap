# JDragonSoap
一个基于AFNetworking的网络请求

更新日志：基于AFNetworking 3.1  

NSURLConnection 替换为NSURLSession 

##setup

### user pod

```

pod 'JDragonSoap','~> 0.0.4'


```


## 如何使用


```
[JDragonSoap shareInstance].urlHost =@"";
[JDragonSoap shareInstance].parameter = @{};


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



```


## other

详细请看demo







