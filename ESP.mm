#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// --- [ ئۆفسێتەکان - پێویستە ڕاست بن بۆ جوڵە ] ---
uintptr_t kGWorld = 0x10A2B45F0; 
uintptr_t kViewMatrix = 0x10A2C56E8;

struct Vector3 { float x, y, z; };
struct Matrix4x4 { float m[16]; };

@interface KamoHunterESP : UIView
@end

@implementation KamoHunterESP
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        [[CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

// هاوکێشەی WorldToScreen بۆ گۆڕینی شوێنی 3D بۆ سەر شاشە
- (BOOL)worldToScreen:(Vector3)world pos:(CGPoint *)screen matrix:(Matrix4x4)matrix {
    float w = matrix.m[3] * world.x + matrix.m[7] * world.y + matrix.m[11] * world.z + matrix.m[15];
    if (w < 0.01f) return NO;

    float x = matrix.m[0] * world.x + matrix.m[4] * world.y + matrix.m[8] * world.z + matrix.m[12];
    float y = matrix.m[1] * world.x + matrix.m[5] * world.y + matrix.m[9] * world.z + matrix.m[13];

    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;

    screen->x = (screenWidth / 2) * (1 + x / w);
    screen->y = (screenHeight / 2) * (1 - y / w);
    return YES;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) return;

    // تێکستی سەرەوە
    [@"KAMO HUNTER • SEEKING ENEMIES" drawAtPoint:CGPointMake(rect.size.width/2-80, 50) withAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];

    // لێرەدا کۆدەکە دەگەڕێت بەدوای دوژمندا (بۆ نموونە ئەگەر ئۆفسێتەکان زانیاری بدەن)
    // ئەمە نموونەیەکی جوڵاوە کە بەستراوەتەوە بە هاوکێشەی ماتماتیکی
    float x = rect.size.width/2;
    float y = rect.size.height/2;

    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineWidth(ctx, 1.8);
    CGContextStrokeRect(ctx, CGRectMake(x-40, y-80, 80, 160));

    // Snapline
    CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor);
    CGContextMoveToPoint(ctx, rect.size.width/2, rect.size.height);
    CGContextAddLineToPoint(ctx, x, y + 80);
    CGContextStrokePath(ctx);
}
@end

__attribute__((constructor))
static void initialize() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIScene *scene in [[UIApplication sharedApplication] connectedScenes]) {
            UIWindow *window = [(UIWindowScene *)scene windows].firstObject;
            [window addSubview:[[KamoHunterESP alloc] initWithFrame:window.bounds]];
        }
    });
}
