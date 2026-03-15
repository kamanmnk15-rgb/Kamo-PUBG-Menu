#import <UIKit/UIKit.h>

@interface KamoESP : NSObject
@end

@implementation KamoESP

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *w in windowScene.windows) {
                        if (w.isKeyWindow) {
                            window = w;
                            break;
                        }
                    }
                }
            }
        } else {
            window = [UIApplication sharedApplication].keyWindow;
        }

        if (window) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 250, 50)];
            label.text = @"KAMO ESP CONNECTED ✅";
            label.textColor = [UIColor greenColor];
            label.font = [UIFont boldSystemFontOfSize:18];
            label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 10;
            label.clipsToBounds = YES;
            [window addSubview:label];
        }
    });
}

@end
