#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// تاقیکردنەوەی لیستێک لە ئۆفسێتە ئەگەرییەکان بۆ ئەوەی بزانین کامەیان دەجوڵێت
uintptr_t matrixList[] = {
    0x14F6B3D8, // کۆن
    0x152E4A10, // ئەگەری ١
    0x151D8B40, // ئەگەری ٢
    0x153A1C20, // ئەگەری ٣
    0x14F5A2C0  // ئەگەری ٤
};

@interface KamoGlobalFix : UIView
@end

@implementation KamoGlobalFix
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        [[CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // ئاگادارکردنەوەی جۆری نوێ
    [@"KAMO ESP • TESTING MATRIX" drawAtPoint:CGPointMake(rect.size.width/2-85, 60) withAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];

    float x = rect.size.width / 2;
    float y = rect.size.height / 2;

    // کێشانی چوارگۆشەیەکی زەرد (بۆ ئەوەی بزانیت ئەمە کۆدە نوێیەکەیە)
    CGContextSetStrokeColorWithColor(ctx, [UIColor yellowColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokeRect(ctx, CGRectMake(x-40, y-80, 80, 160));
}
@end

__attribute__((constructor))
static void load_fix() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        [win addSubview:[[KamoGlobalFix alloc] initWithFrame:win.bounds]];
    });
}
