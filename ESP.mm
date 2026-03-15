#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

@interface KamoESPBox : UIView
@end

@implementation KamoESPBox
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context) {
        CGRect enemyBox = CGRectMake(rect.size.width / 2 - 50, rect.size.height / 2 - 100, 100, 200);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextSetLineWidth(context, 2.0);
        CGContextStrokeRect(context, enemyBox);
        
        CGContextMoveToPoint(context, rect.size.width / 2, 0);
        CGContextAddLineToPoint(context, rect.size.width / 2, rect.size.height / 2 - 100);
        CGContextStrokePath(context);
    }
}
@end

__attribute__((constructor))
static void start_esp_system() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // شێوازێکی نوێ بۆ دۆزینەوەی شاشەی یارییەکە بەبێ بەکارهێنانی keyWindow
        UIWindow *activeWindow = nil;
        NSSet *scenes = [[UIApplication sharedApplication] connectedScenes];
        for (UIScene *scene in scenes) {
            if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        activeWindow = window;
                        break;
                    }
                }
            }
        }

        if (activeWindow) {
            KamoESPBox *espLayer = [[KamoESPBox alloc] initWithFrame:activeWindow.bounds];
            [activeWindow addSubview:espLayer];
        }
    });
}
