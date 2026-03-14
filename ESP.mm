#import <UIKit/UIKit.h>

// ئەمانە پێیان دەوترێت ئۆفسێت - بۆ هەر ڤێرژنێکی یارییەکە دەگۆڕێن
#define GWorld 0x1234567  // ئەمە تەنها نموونەیە
#define LineOfSight 0x7654321

@interface ESPView : UIView
@end

@implementation ESPView
- (void)drawRect:(CGRect)rect {
    // لێرەدا کۆدی کێشانی هێڵەکان و سندوقەکان دەنووسرێت
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    // کێشانی سندوقێکی نموونەیی لەسەر شاشە
    CGContextAddRect(context, CGRectMake(100, 100, 50, 100));
    CGContextStrokePath(context);
}
@end

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        ESPView *esp = [[ESPView alloc] initWithFrame:keyWindow.bounds];
        esp.backgroundColor = [UIColor clearColor];
        esp.userInteractionEnabled = NO;
        [keyWindow addSubview:esp];
        
        NSLog(@"Kamo ESP Activated!");
    });
}
