#import <UIKit/UIKit.h>

@interface KamoESP : UIView
@end

@implementation KamoESP

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject;
                break;
            }
        }
        KamoESP *espView = [[KamoESP alloc] initWithFrame:[UIScreen mainScreen].bounds];
        espView.backgroundColor = [UIColor clearColor];
        espView.userInteractionEnabled = NO;
        [window addSubview:espView];
    });
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);

    // دروستکردنی بۆکسێکی تێست لە ناوەڕاستی شاشە
    CGRect box = CGRectMake(rect.size.width/2 - 50, rect.size.height/2 - 100, 100, 200);
    CGContextAddRect(context, box);
    CGContextStrokePath(context);
}

@end
