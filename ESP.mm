#import <UIKit/UIKit.h>

@interface KamoESP : NSObject
@end

@implementation KamoESP

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
        label.text = @"KAMO ESP LOADED!";
        label.textColor = [UIColor greenColor];
        label.font = [UIFont boldSystemFontOfSize:20];
        [[UIApplication sharedApplication].keyWindow addSubview:label];
    });
}

@end
