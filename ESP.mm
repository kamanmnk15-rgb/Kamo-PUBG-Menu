#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// --- [1] دروستکردنی شاشەی ESP کە نوێ دەبێتەوە ---
@interface KamoESPView : UIView
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation KamoESPView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        // دروستکردنی لووپ بۆ ئەوەی ESPەکە نەپچڕێت و بجوڵێت
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateESP)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)updateESP {
    [self setNeedsDisplay]; // ئەمە وادەکات شاشەکە ٦٠ جار لە چرکەیەکدا نوێ بێتەوە
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return;

    // لێرەدا ڕەنگی چوارگۆشەکە دەگۆڕین بۆ سەوز (وەک ESPی پرۆفیشناڵ)
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(context, 1.5);

    /* تێبینی: لێرەدا دەبێت لە داهاتوودا کۆدی خوێندنەوەی (X, Y)ی دوژمن دابنێین.
       بۆ ئێستا، چوارگۆشەیەک بە نموونە دادەنێین کە کەمێک دەجوڵێت بۆ ئەوەی بزانیت لووپەکە ئیش دەکات.
    */
    
    static float moveX = 0;
    moveX += 0.5; if(moveX > 100) moveX = 0; // تاقیکردنەوەی جوڵە

    CGRect enemyBox = CGRectMake(rect.size.width / 2 - 50 + moveX, rect.size.height / 2 - 80, 80, 160);
    CGContextStrokeRect(context, enemyBox);
}
@end

// --- [2] چالاککەر ---
__attribute__((constructor))
static void init_kamo_esp() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *activeWin = nil;
        for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow* window in scene.windows) {
                    if (window.isKeyWindow) { activeWin = window; break; }
                }
            }
        }

        if (activeWin) {
            KamoESPView *esp = [[KamoESPView alloc] initWithFrame:activeWin.bounds];
            [activeWin addSubview:esp];
        }
    });
}
