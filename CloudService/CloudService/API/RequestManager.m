 

#import "RequestManager.h"
#import "RestAPI.h"
#import "AFNetworking.h"

@implementation RequestManager

+(AFHTTPSessionManager *)requestManagerWithBaseURL:(NSString *)baseURLString {
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    [manager.reachabilityManager startMonitoring];
    
    return manager;
}

+ (void)startRequest:(NSString *)url
             paramer:(NSDictionary *)paramers
              method:(RequestMethod)method
             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    AFHTTPSessionManager *manager = [self requestManagerWithBaseURL:BaseAPI];
    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    AFJSONResponseSerializer* jsonResponseSerializer = [AFJSONResponseSerializer serializer];
//    jsonResponseSerializer.removesKeysWithNullValues = YES;
//    jsonResponseSerializer.readingOptions = NSJSONReadingAllowFragments;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //添加一个可以接受的类型，因为有时候返回值不为json
    NSMutableSet *acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes mutableCopy];
    [acceptableContentTypes addObject:@"text/json; charset=utf-8"];
//    manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    
    NSString *path = [BaseAPI stringByAppendingString:url]; 
    
    if (method == RequestMethodGet) {
        
        [manager GET:path parameters:paramers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            success(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            failure(task,error);
        }];
        
    }else if (method == RequestMethodPost) {
        
        [manager POST:path parameters:paramers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            success(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            failure(task,error);
        }];
        
    } else if (method == RequestMethodDelete) { 
        
        [manager DELETE:path parameters:paramers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            success(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            failure(task,error);
        }];
        
    }
}

#warning 上传和下载还不完善,有待修改
+ (void)uploadFile:(NSData *)postData completionHandler:(void(^)(id responseObject))completion progressHandler:(void(^)(long long p))progressBlock failureHandler:(void(^)(NSError *error))failure {
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    NSString *path = [BaseAPI stringByAppendingString:UploadImageAPI];
    NSString *path = nil;
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:path parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:postData
                                    name:@"bin"
                                fileName:@"image.jpg"
                                mimeType:@"application/octet-stream"];
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
}

+ (void)downloadFileRquestWithFileUrl:(NSString *)fileUrl progress:(void(^)(NSProgress *))progressHander completionHandler:(void(^)(id responseObject))completionHandler failerHandler:(void(^)(NSError *error))failerHandler{
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
//    __block NSProgress *downLoadProgress = nil;
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&downLoadProgress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//        
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSLog(@"File downloaded to: %@", filePath);
//    }];
//    
//    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
//        
//    }];
//    
//    [downloadTask resume];
    
}

@end
