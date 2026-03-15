#import <UIKit/UIKit.h>

@interface KamoOverlay : UIView
@end

@implementation KamoOverlay

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                keyWindow = scene.windows.firstObject;
                break;
            }
        }
        
        KamoOverlay *overlay = [[KamoOverlay alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlay.backgroundColor = [UIColor clearColor];
        overlay.userInteractionEnabled = NO;
        [keyWindow addSubview:overlay];
    });
}

- (void)drawRect:(CGRect)rect {
    // دروستکردنی هێڵێکی تێست بۆ دڵنیابوونەوە لە کارکردنی ESP
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.size.width / 2, 0)];
    [path addLineToPoint:CGPointMake(rect.size.width / 2, rect.size.height)];
    [[UIColor greenColor] setStroke];
    path.lineWidth = 2.0;
    [path stroke];
    
    // نووسینی دەقێک لە ناوەڕاست
    NSString *text = @"KAMO ESP ACTIVE ✅";
    [text drawAtPoint:CGPointMake(rect.size.width / 2 - 50, 100) withAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}];
}

@end
