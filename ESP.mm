#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// --- [ ئەمانە ئۆفسێتەکانن - بەنزینەکە ] ---
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
        // بزوێنەری نوێکردنەوە (60 جار لە چرکەیەکدا)
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) return;

    // کێشانی چوارگۆشە سەوزەکە
    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    
    // لێرەدا کاتێک ئۆفسێتەکانمان دۆزییەوە، ئەم چوارگۆشەیە دەجوڵێنین
    CGRect box = CGRectMake(rect.size.width/2 - 50, rect.size.height/2 - 100, 100, 200);
    CGContextStrokeRect(ctx, box);
}
@end

// --- [ چالاککەری هاکەکە بەبێ کێشەی keyWindow ] ---
__attribute__((constructor))
static void start_kamo_engine() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *mainWin = nil;
        // بەکارهێنانی فێڵێکی مۆدێرن بۆ دۆزینەوەی شاشە تا گیتھەب Error نەدات
        for (UIScene *scene in [[UIApplication sharedApplication] connectedScenes]) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *winScene = (UIWindowScene *)scene;
                for (UIWindow *win in winScene.windows) {
                    if (win.isKeyWindow) {
                        mainWin = win;
                        break;
                    }
                }
            }
        }

        if (mainWin) {
            KamoFinalESP *overlay = [[KamoFinalESP alloc] initWithFrame:mainWin.bounds];
            [mainWin addSubview:overlay];
        }
    });
}
