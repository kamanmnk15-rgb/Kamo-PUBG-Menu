#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// ئۆفسێتی وەشانی Global 1.8.54
uintptr_t kViewMatrix = 0x14F6B3D8; 

@interface KamoFinalFix : UIView
@end

@implementation KamoFinalFix
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        [[CADisplayLink displayLinkWithTarget:self selector:@selector(update)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)update { [self setNeedsDisplay]; }

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [@"KAMO ESP • iOS 18 READY" drawAtPoint:CGPointMake(rect.size.width/2-75, 70) withAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:10]}];

    float midX = rect.size.width / 2;
    float midY = rect.size.height / 2;
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor systemPinkColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokeRect(ctx, CGRectMake(midX-35, midY-75, 70, 150));
}
@end

// ئەم بەشە چاککراوە بۆ ئەوەی هەڵەی keyWindow نەیەت
__attribute__((constructor))
static void load_kamo_ios18() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *activeWindow = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *window in scene.windows) {
                        if (window.isKeyWindow) {
                            activeWindow = window;
                            break;
                        }
                    }
                }
            }
        } else {
            activeWindow = [UIApplication sharedApplication].keyWindow;
        }

        if (activeWindow) {
            KamoFinalFix *esp = [[KamoFinalFix alloc] initWithFrame:activeWindow.bounds];
            [activeWindow addSubview:esp];
        }
    });
}
