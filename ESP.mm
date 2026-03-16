#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// ئۆفسێتە نوێیەکانی Global 1.8.54
uintptr_t kGWorld = 0x14F5A2C0; 
uintptr_t kViewMatrix = 0x14F6B3D8;

@interface KamoGlobalESP : UIView
@end

@implementation KamoGlobalESP
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        // ڕێفرێشی شاشە
        [[CADisplayLink displayLinkWithTarget:self selector:@selector(update)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)update { [self setNeedsDisplay]; }

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // نیشانەیەک بۆ دڵنیابوون لە کارکردنی کۆدەکە
    [@"KAMO GLOBAL v1.8.54" drawAtPoint:CGPointMake(rect.size.width/2-70, 60) withAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];

    float midX = rect.size.width / 2;
    float midY = rect.size.height / 2;
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    
    // کێشانی چوارگۆشەی ئامانج
    CGContextStrokeRect(ctx, CGRectMake(midX-40, midY-80, 80, 160));
}
@end

__attribute__((constructor))
static void load_kamo() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if (window.isKeyWindow) {
                [window addSubview:[[KamoGlobalESP alloc] initWithFrame:window.bounds]];
                break;
            }
        }
    });
}
