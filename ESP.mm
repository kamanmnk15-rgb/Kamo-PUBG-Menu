#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// --- [ ئەمانە ئەو ژمارانەن کە دەبێت بیدۆزینەوە ] ---
uintptr_t kGWorld = 0x0; 
uintptr_t kViewMatrix = 0x0;

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

    // کێشانی هێڵێک لە ژێرەوە بۆ ناوەڕاست (Snapline) وەک تێست
    CGContextSetStrokeColorWithColor(ctx, [UIColor cyanColor].CGColor);
    CGContextSetLineWidth(ctx, 1.5);
    CGContextMoveToPoint(ctx, rect.size.width/2, rect.size.height);
    CGContextAddLineToPoint(ctx, rect.size.width/2, rect.size.height/2);
    CGContextStrokePath(ctx);
    
    // نیشاندانی تێکست
    [@"Kamo Engine: Waiting for Offsets..." drawAtPoint:CGPointMake(50, 50) withAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]}];
}
@end

__attribute__((constructor))
static void init_kamo() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIWindowScene* scene in [[UIApplication sharedApplication] connectedScenes]) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                UIWindow *win = [scene windows].firstObject;
                [win addSubview:[[KamoUltimateESP alloc] initWithFrame:win.bounds]];
                break;
            }
        }
    });
}
