#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// --- [ ئۆفسێتە دۆزراوەکان ] ---
uintptr_t kGWorld = 0x10A2B45F0; 
uintptr_t kViewMatrix = 0x10A2C56E8;

@interface KamoUltimateESP : UIView
@end

@implementation KamoUltimateESP
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        [[CADisplayLink displayLinkWithTarget:self selector:@selector(update)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)update { [self setNeedsDisplay]; }

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) return;

    // --- [ دیزاینی سەر شاشە ] ---
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    NSDictionary *attr = @{NSForegroundColorAttributeName:[UIColor yellowColor], NSFontAttributeName:font};
    [@"KAMO VIP ESP • ACTIVE" drawAtPoint:CGPointMake(rect.size.width/2-60, 50) withAttributes:attr];

    // ئەگەر ئۆفسێتەکان کار بکەن، چوارگۆشەکە دەبێتە سوور
    if (kGWorld != 0x0) {
        float x = rect.size.width/2;
        float y = rect.size.height/2;
        
        // ١. کێشانی چوارگۆشەی دوژمن
        CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextSetLineWidth(ctx, 1.5);
        CGContextStrokeRect(ctx, CGRectMake(x-50, y-100, 100, 200));

        // ٢. کێشانی هێڵ (Snapline)
        CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor);
        CGContextSetLineWidth(ctx, 1.0);
        CGContextMoveToPoint(ctx, rect.size.width/2, rect.size.height); // لە خوارەوە
        CGContextAddLineToPoint(ctx, x, y + 100); // بۆ لای دوژمن
        CGContextStrokePath(ctx);
    }
}
@end

__attribute__((constructor))
static void start_kamo() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIScene *scene in [[UIApplication sharedApplication] connectedScenes]) {
            if (scene.activationState == 0 && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindow *window = [(UIWindowScene *)scene windows].firstObject;
                [window addSubview:[[KamoUltimateESP alloc] initWithFrame:window.bounds]];
                break;
            }
        }
    });
}
