#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// --- [ پڕکردنەوەی ژمارە دۆزراوەکان ] ---
uintptr_t kGWorld = 0x10A2B45F0; 
uintptr_t kViewMatrix = 0x10A2C56E8;

@interface KamoFinalESP : UIView
@end

@implementation KamoFinalESP
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        [[CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) return;

    // ئەگەر ئۆفسێتەکان کار بکەن ڕەنگەکە دەبێتە سوور
    if (kGWorld != 0x0) {
        CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    } else {
        CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    }

    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokeRect(ctx, CGRectMake(rect.size.width/2-50, rect.size.height/2-100, 100, 200));
}
@end

__attribute__((constructor))
static void start_kamo() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIScene *scene in [[UIApplication sharedApplication] connectedScenes]) {
            if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == 0) {
                UIWindow *window = [(UIWindowScene *)scene windows].firstObject;
                [window addSubview:[[KamoFinalESP alloc] initWithFrame:window.bounds]];
                break;
            }
        }
    });
}
