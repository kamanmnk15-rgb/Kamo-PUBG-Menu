#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// --- [1] دروستکردنی شاشەی ESP ---
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
    
    // کێشانی چوارگۆشەی تاقیکردنەوە
    CGRect enemyBox = CGRectMake(rect.size.width / 2 - 50, rect.size.height / 2 - 100, 100, 200);
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextStrokeRect(context, enemyBox);
    
    // کێشانی هێڵ
    CGContextMoveToPoint(context, rect.size.width / 2, 0);
    CGContextAddLineToPoint(context, rect.size.width / 2, rect.size.height / 2 - 100);
    CGContextStrokePath(context);
}
@end

// --- [2] چالاککەر بە شێوازی نوێ ---
__attribute__((constructor))
static void start_esp_system() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *mainWin = nil;
        // چارەسەری کێشەی keyWindow بۆ وەشانە نوێیەکانی iOS
        for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow* window in scene.windows) {
                    if (window.isKeyWindow) {
                        mainWin = window;
                        break;
                    }
                }
            }
        }
        
        // ئەگەر شێوازە نوێیەکە کاری نەکرد، پەنا دەبەینە بەر کۆنەکە بۆ دڵنیایی
        if (!mainWin) {
            mainWin = [UIApplication sharedApplication].keyWindow;
        }

        if (mainWin) {
            KamoESPBox *espLayer = [[KamoESPBox alloc] initWithFrame:mainWin.bounds];
            [mainWin addSubview:espLayer];
            NSLog(@"[KAMO] ESP Box Overlay Activated!");
        }
    });
}
