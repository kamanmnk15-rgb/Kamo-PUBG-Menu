#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

uintptr_t GWorld = 0x0; 

uintptr_t get_main_address() {
    return _dyld_get_image_vmaddr_slide(0) + 0x100000000;
}

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

    // لێرەدا 'base' بەکاردێنین تاوەکو چیتر Error نەیەت
    uintptr_t base = get_main_address();
    
    if (base > 0 && GWorld != 0x0) {
        CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
    } else {
        CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    }

    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokeRect(ctx, CGRectMake(rect.size.width/2-50, rect.size.height/2-100, 100, 200));
}
@end

__attribute__((constructor))
static void start_kamo_esp() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = nil;
        for (UIScene *scene in [[UIApplication sharedApplication] connectedScenes]) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                win = [[(UIWindowScene *)scene windows] firstObject];
                break;
            }
        }
        if (win) {
            [win addSubview:[[KamoFinalESP alloc] initWithFrame:win.bounds]];
        }
    });
}
