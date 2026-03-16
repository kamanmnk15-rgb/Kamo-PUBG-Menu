#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// ئەمانە نوێترین ئۆفسێتی وەشانی Global 1.8.54 ن کە لە سۆرسە جیاوازەکان وەرگیراون
uintptr_t kViewMatrix = 0x14F6B3D8; 
uintptr_t kGWorld = 0x14F5A2C0;

@interface KamoFinalESP : UIView
@end

@implementation KamoFinalESP
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
    
    // نووسینی تاقیکردنەوە بە ڕەنگی سپی
    [@"KAMO ESP • TESTING NEW OFFSETS" drawAtPoint:CGPointMake(rect.size.width/2-90, 70) withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:10]}];

    float midX = rect.size.width / 2;
    float midY = rect.size.height / 2;
    
    // کێشانی چوارگۆشەیەکی پەمەیی (بۆ ئەوەی بزانیت ئەمە کۆدە نوێیەکەیە)
    CGContextSetStrokeColorWithColor(ctx, [UIColor systemPinkColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    
    // ئەگەر ئۆفسێتەکان ئیش بکەن، ئەم چوارگۆشەیە دەبێت بە پێی جوڵەی کامێرا بلەرزێت یان بجوڵێت
    CGContextStrokeRect(ctx, CGRectMake(midX-35, midY-75, 70, 150));
}
@end

__attribute__((constructor))
static void load_kamo_final() {
    // ٤٠ چرکە چاوەڕێ بکە تا دەچیتە ناو مەشق (Training)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window) {
            [window addSubview:[[KamoFinalESP alloc] initWithFrame:window.bounds]];
        }
    });
}
