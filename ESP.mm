#import <UIKit/UIKit.h>
#import <mach/mach.h>

// --- [بەشی ئۆفسێتەکان - لێرەدا ژمارەکان دادەنێین] ---
uintptr_t OFFSET_GWorld = 0x0;        // دەبێت بدۆزرێتەوە
uintptr_t OFFSET_ViewMatrix = 0x0;   // دەبێت بدۆزرێتەوە
uintptr_t OFFSET_EntityList = 0x0;   // دەبێت بدۆزرێتەوە

@interface KamoProESP : UIView
@end

@implementation KamoProESP
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        [CADisplayLink displayLinkWithTarget:self selector:@selector(update)].priority = 1;
        [[CADisplayLink displayLinkWithTarget:self selector:@selector(update)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)update { [self setNeedsDisplay]; }

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) return;

    // --- لێرەدا کۆدی دۆزینەوەی دوژمن دەنووسرێت ---
    // ئەگەر OFFSET_GWorld سفر نەبوو، دەست دەکات بە کێشانی چوارگۆشە بە دوای دوژمن
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    
    // کێشانی چوارگۆشە (بۆ ئێستا وەک نموونە)
    CGContextStrokeRect(ctx, CGRectMake(rect.size.width/2-50, rect.size.height/2-100, 100, 200));
}
@end

// چالاککەری سەرەکی
__attribute__((constructor))
static void init_pro_esp() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow]; // بۆ تێست، ئەگەر Error دا وەک پێشوو چاکی دەکەین
        [win addSubview:[[KamoProESP alloc] initWithFrame:win.bounds]];
    });
}
