 

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGet,
    RequestMethodPost,
    RequestMethodDelete
};

@interface RequestManager : NSObject
 

+ (void)startRequest:(NSString *)url
             paramer:(NSDictionary *)paramers
              method:(RequestMethod)method
             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)uploadFile:(NSData *)postData
 completionHandler:(void(^)(id responseObject))completion
   progressHandler:(void(^)(long long p))progressBlock
    failureHandler:(void(^)(NSError *error))failure; 



+ (void)downloadFileRquestWithFileUrl:(NSString *)fileUrl progress:(void(^)(NSProgress *))progressHander completionHandler:(void(^)(id responseObject))completionHandler failerHandler:(void(^)(NSError *error))failerHandler;


@end
