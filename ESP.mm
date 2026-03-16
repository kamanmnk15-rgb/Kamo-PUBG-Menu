#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// ئەمە یەکێکە لە ئۆفسێتەکانی ناو وێنەکە (Radar) بۆ تاقیکردنەوە
uintptr_t GWorld_Test = 0x1012F39A0; 

@interface KamoFinalESP : UIView
@end

@implementation KamoFinalESP
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        [[CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) return;

    // ئەگەر ئۆفسێتەکە لە میمۆریدا بدۆزرێتەوە، چوارگۆشەکە دەبێتە سوور
    if (GWorld_Test != 0) {
        CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        // نیشاندانی تێکستێکی بچووک بۆ دڵنیایی
        NSString *status = @"Engine Linked!";
        [status drawAtPoint:CGPointMake(20, 50) withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    } else {
        CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    }

    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokeRect(ctx, CGRectMake(rect.size.width/2-50, rect.size.height/2-100, 100, 200));
}
@end

__attribute__((constructor))
static void start_kamo() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIScene *scene in [[UIApplication sharedApplication] connectedScenes]) {
            if (scene.activationState == 0) {
                UIWindow *win = [[(UIWindowScene *)scene windows] firstObject];
                [win addSubview:[[KamoFinalESP alloc] initWithFrame:win.bounds]];
            }
        }
    });
}
