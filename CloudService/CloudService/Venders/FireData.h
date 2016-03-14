
#import <Foundation/Foundation.h>

@protocol FireDataDelegate <NSObject>

@optional
/* 统计SDK捕获到异常，程序即将崩溃时，回调此函数 */
- (void)onCrash;

/**
 定义协议函数，在SDK内部捕获到对应崩溃事件，并将对应的崩溃事件添加到事件队列后进行对应的事件处理，并将当前获取到的异常信息对象传递
 */
- (void)onCrashAfterAddedToEventArrWithCrashInfo:(NSDictionary *)exception;

@end

@interface FireData : NSObject


+ (FireData *)sharedInstance;

///---------------------------------------------------------------------------------------
/// @name  设置
///---------------------------------------------------------------------------------------

@property (nonatomic, weak) id<FireDataDelegate> delegate;
@property (nonatomic, assign) BOOL debugMode;                   // Debug模式，此时打印调试日志，默认为NO
@property (nonatomic, assign) BOOL enableCrashReport;           // 是否收集APP异常崩溃事件，默认为YES
@property (nonatomic, assign) BOOL enableLocationReport;        // 是否收集地理位置， 默认为NO
@property (nonatomic, assign) int sendTimeInterval;             // check 本地缓存日志间隔，默认为15分钟
@property (nonatomic, assign) int sessionInterval;              // 会话时间间隔，默认为10分钟
@property (nonatomic, assign) int bufferNumber;                 // 日志缓存最高条数限制，默认为50条

@property (nonatomic, copy) NSString *refcode;                  // 设置APP启动来源

@property (nonatomic, strong) NSString *sendBaseUrl;

@property (nonatomic, assign) BOOL enableIDFA;                  // 是否允许获取 IDFA, 默认为允许 YES
@property (nonatomic, assign) BOOL enableIDFV;                  // 是否允许获取 IDFA, 默认为允许 YES
/*
 初始化设置
 */
- (void)initWithHost:(NSString *)url                // 服务端host地址
               AppId:(NSString *)appid              // app id
        distributors:(NSString *)channelId;        // app 渠道

///---------------------------------------------------------------------------------------
/// @name  事件
///---------------------------------------------------------------------------------------
/*
 用户登录
 */
- (void)loginWithUserid:(NSString *)uid uvar:(NSString *)uvar;
/*
 用户退出登录
 */
- (void)logout;


/**
 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 @param pageName 当前所处的页面名称.
 @param attributes pv级作用域的参数, 应包含 cid:cid, cch:channel, cchs:subchannel
 @param cvar 内容额外参数
 @return void.
 */
- (void)beginLogPageView:(NSString *)pageName
              attributes:(NSDictionary *)attributes
                    cvar:(NSString *)cvar;

/**
 必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 @param pageName 统计的页面名称.
 @return void.
 */
- (void)endLogPageView:(NSString *)pageName;

/*
 自定义事件
 @param category 事件分类 (如：Videos, Music, Games...)
 @param action 动作 (如Play, Pause, Duration, Buy)
 @param name 名字，(如视频名字，歌曲名字等), 可选
 @value value 事件的值，可选
 @param attributes 额外统计参数（可选，预留，若有值则以 key1=value1&key2=value2的形式加入post参数中）
 @return void.
 */
- (void)eventWithCategory:(NSString *)category
                   action:(NSString *)action
                     name:(NSString *)name
                    value:(NSString *)value
               attributes:(NSDictionary *)attributes;

///---------------------------------------------------------------------------------------
/// @name  公用参数
///---------------------------------------------------------------------------------------
- (NSString *)guid;
- (NSString *)idfa;
- (NSString *)idfv;
- (NSString *)analyticsSDKVersion;
@end