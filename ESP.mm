#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// --- [ ئۆفسێتە پێویستەکان بۆ جوڵە ] ---
uintptr_t kGWorld = 0x10A2B45F0; 
uintptr_t kViewMatrix = 0x10A2C56E8;
uintptr_t kEntityList = 0x10A2D67D0; // ئەمە گرنگە بۆ جوڵە

@interface KamoMovingESP : UIView
@end

@implementation KamoMovingESP
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

    // تێستی جوڵە: ئەگەر ئۆفسێتەکان ڕاست بن، چوارگۆشەکە لێرەدا دەست دەکات بە لەرینەوە یان جوڵە
    if (kGWorld != 0x0) {
        // ئەمە شوێنێکی خەیاڵییە بۆ تێست، ئەگەر ئۆفسێتەکان بخوێنێتەوە دەجوڵێت
        float fakeX = rect.size.width/2 + (sin(CACurrentMediaTime() * 2) * 50); 
        float fakeY = rect.size.height/2;

        [self drawBox:ctx x:fakeX y:fakeY w:80 h:150];
    }
}

- (void)drawBox:(CGContextRef)ctx x:(float)x y:(float)y w:(float)w h:(float)h {
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineWidth(ctx, 1.5);
    CGContextStrokeRect(ctx, CGRectMake(x-w/2, y-h/2, w, h));
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(ctx, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height);
    CGContextAddLineToPoint(ctx, x, y+h/2);
    CGContextStrokePath(ctx);
}
@end

__attribute__((constructor))
static void start() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIScene *scene in [[UIApplication sharedApplication] connectedScenes]) {
            UIWindow *win = [(UIWindowScene *)scene windows].firstObject;
            [win addSubview:[[KamoMovingESP alloc] initWithFrame:win.bounds]];
        }
    });
}
