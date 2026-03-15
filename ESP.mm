#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// --- [بەشی ئۆفسێتەکان - لێرەدا ژمارەکان پڕ دەکەینەوە] ---
uintptr_t GWorld = 0x0; 
uintptr_t ViewMatrix = 0x0;
uintptr_t EntityList = 0x0;

@interface KamoFinalESP : UIView
@end

@implementation KamoFinalESP
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) return;

    // کێشانی چوارگۆشەی تێست
    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokeRect(ctx, CGRectMake(rect.size.width/2-50, rect.size.height/2-100, 100, 200));
}
@end

__attribute__((constructor))
static void start_kamo_esp() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *activeWin = nil;
        // چارەسەری مۆدێرن بۆ ئەوەی گیتھەب Error نەدات
        NSArray *scenes = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        for (id scene in scenes) {
            if ([scene respondsToSelector:@selector(activationState)] && 
                [scene activationState] == 0) { // 0 = Active
                activeWin = [[scene performSelector:@selector(windows)] firstObject];
                break;
            }
        }

        if (activeWin) {
            KamoFinalESP *overlay = [[KamoFinalESP alloc] initWithFrame:activeWin.bounds];
            [activeWin addSubview:overlay];
        }
    });
}
