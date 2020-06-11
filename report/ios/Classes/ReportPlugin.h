#import <Flutter/Flutter.h>
#import <Bugly/Bugly.h>

@interface ReportPlugin : NSObject<FlutterPlugin>
+(void)startWithAppId:(NSString*)appId :(Boolean)debugMode;
@end
