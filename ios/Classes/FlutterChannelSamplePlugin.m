#import "FlutterChannelSamplePlugin.h"
#import "DataChannel.pbobjc.h"

@interface TestCodec : NSObject<FlutterMessageCodec>

@end

@implementation TestCodec
+ (instancetype)sharedInstance{
    static TestCodec *p = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (p == nil) {
            p = [[TestCodec alloc] init];
        }
    });
    return p;
}

- (NSData* _Nullable)encode:(id _Nullable)message{
    LeafDataChannel *model = message;
    return   model.data;
}

/**
 * Decodes the specified message from binary.
 *
 * @param message The message.
 * @return The decoded message, or `nil`, if `message` was `nil`.
 */
- (id _Nullable)decode:(NSData* _Nullable)message{
    NSError *err = nil;
    LeafDataChannel *data = [[LeafDataChannel alloc] initWithData:message error:&err];
    return data;
}
@end

@implementation FlutterChannelSamplePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_channel_sample"
            binaryMessenger:[registrar messenger]];
  FlutterChannelSamplePlugin* instance = [[FlutterChannelSamplePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterBasicMessageChannel* myTestChannel  = [[FlutterBasicMessageChannel alloc] initWithName:@"flutter_channel_sample.data" binaryMessenger:[registrar messenger] codec:[TestCodec sharedInstance]];
    [myTestChannel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) {
        NSLog(@"接收到flutter 数据");
        LeafDataChannel *model = message;
        NSLog(@"接收到flutter 数据: %@", model.path);
        
        LeafDataChannel *back = [[LeafDataChannel alloc] init];
        back.path = @"back";
        callback(back);
    }];
    
    FlutterBasicMessageChannel* myTestChannel2  = [[FlutterBasicMessageChannel alloc] initWithName:@"flutter_channel_sample.json" binaryMessenger:[registrar messenger] codec:[FlutterJSONMessageCodec sharedInstance]];
    [myTestChannel2 setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) {
        NSLog(@"接收到flutter 数据");
        NSArray *model = message;
        NSLog(@"接收到flutter 数据: %ld -- %@",model.count, model.firstObject);
        
        
        callback(nil);
    }];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"batchStringToNavtive" isEqualToString:call.method]) {
     
      NSString* path = call.arguments[@"path"];
      NSArray* strList = call.arguments[@"batchStringList"];
      NSLog(@"batchStringFoNavtive path: %@", path);
      NSLog(@"batchStringFoNavtive strList Count: %ld", strList.count);
      result(@"done!");
  }else if ([@"batchProtoBufToNavtive" isEqualToString:call.method]) {
      NSError *err = nil;
      FlutterStandardTypedData *fx = call.arguments[@"data"];
      LeafDataChannel *xx = [LeafDataChannel parseFromData:fx.data error:&err];
      NSLog(@"batchStringFoNavtive path: %@", xx.path);
      NSLog(@"batchStringFoNavtive strList Count: %ld -- %@", xx.sqlListArray_Count ,xx.sqlListArray.firstObject);
      result(@"done!");
  }else if ([@"filePassData" isEqualToString:call.method]) {
//      NSString *path = call.arguments[@"filePath"];
//      NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//
//      NSArray *dataList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//
//      NSLog(@"batchStringFoNavtive strList Count: %ld -- %@", dataList.count ,dataList.firstObject);
//
//      result(@"done!");
//      [[NSFileManager defaultManager] removeItemAtPath:path error:nil];

      
      // 异步执行任务创建方法
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          // 这里放异步执行任务代码
          NSString *path = call.arguments[@"filePath"];
          NSData *data = [[NSData alloc] initWithContentsOfFile:path];

          NSArray *dataList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

          NSLog(@"batchStringFoNavtive strList Count: %ld -- %@", dataList.count ,dataList.firstObject);

          dispatch_async(dispatch_get_main_queue(), ^{
              result(@"done!");
              [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
          });
      });
     
  }else {
    result(FlutterMethodNotImplemented);
  }
}

@end
