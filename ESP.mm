#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// ئۆفسێتی جیهانی بۆ تاقیکردنەوە
uintptr_t kViewMatrix = 0x14F6B3D8; 

@interface KamoFinalWinner : UIView
@end

@implementation KamoFinalWinner
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
    
    [@"KAMO ESP • BUILD SUCCESS" drawAtPoint:CGPointMake(rect.size.width/2-70, 75) withAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:10]}];

    float midX = rect.size.width / 2;
    float midY = rect.size.height / 2;
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor yellowColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokeRect(ctx, CGRectMake(midX-35, midY-75, 70, 150));
}
@end

__attribute__((constructor))
static void load_kamo_safe() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *activeWin = nil;
        
        // دۆزینەوەی پەنجەرەی یارییەکە بە بێ بەکارهێنانی keyWindow
        if (@available(iOS 13.0, *)) {
            NSSet *scenes = [UIApplication sharedApplication].connectedScenes;
            for (UIWindowScene *scene in scenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *win in scene.windows) {
                        if (win.isKeyWindow) {
                            activeWin = win;
                            break;
                        }
                    }
                }
            }
        }
        
        // ئەگەر بەو شێوازەش نەدۆزرایەوە، پەنجەرەی یەکەم وەردەگرین
        if (!activeWin) {
            activeWin = [[UIApplication sharedApplication] windows].firstObject;
        }

        if (activeWin) {
            KamoFinalWinner *esp = [[KamoFinalWinner alloc] initWithFrame:activeWin.bounds];
            [activeWin addSubview:esp];
        }
    });
}
