#import "ReportPlugin.h"
#if __has_include(<report/report-Swift.h>)
#import <report/report-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "report-Swift.h"
#endif

@implementation ReportPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftReportPlugin registerWithRegistrar:registrar];
}
@end
