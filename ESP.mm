#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// --- [بەشی ئۆفسێتەکان - لێرەدا بەنزینەکە دادەنێین] ---
uintptr_t GWorld = 0x0; 

// فەرمانی دۆزینەوەی ناونیشانی یارییەکە (ASLR Bypass)
uintptr_t get_main_address() {
    return _dyld_get_image_vmaddr_slide(0) + 0x100000000;
}

@interface KamoBrainESP : UIView
@end

@implementation KamoBrainESP
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)update {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) return;

    // لێرەدا تاقیکردنەوەیەک دەکەین: ئەگەر ئۆفسێتمان دانا، چوارگۆشەکە دەجوڵێت
    uintptr_t base = get_main_address();
    
    if (GWorld != 0x0) {
        // لێرەدا کۆدی دۆزینەوەی دوژمن دەخرێتە گەڕ
        // بۆ ئێستا تەنها ڕەنگەکە دەگۆڕین بۆ ئاڵتونی ئەگەر ئۆفسێت هەبێت
        CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
    } else {
        CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    }

    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokeRect(ctx, CGRectMake(rect.size.width/2-50, rect.size.height/2-100, 100, 200));
}
@end

__attribute__((constructor))
static void start_engine() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIWindowScene* scene in [[UIApplication sharedApplication] connectedScenes]) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindow *win = [[(UIWindowScene *)scene windows] firstObject];
                [win addSubview:[[KamoBrainESP alloc] initWithFrame:win.bounds]];
                break;
            }
        }
    });
}
