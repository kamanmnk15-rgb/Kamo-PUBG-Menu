#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// --- [1] دروستکردنی شاشەی ESP ---
@interface KamoESPBox : UIView
@end

@implementation KamoESPBox
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO; // بۆ ئەوەی ڕێگری لە یاری نەکات
    }
    return self;
}

// ئەم بەشە چوارگۆشەکان دەکێشێت
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // کێشانی نموونەیەک لە ESP Box (ڕەنگی سوور)
    // تێبینی: ئەمە تەنها بۆ تێستە تا بزانیت ESPـەکە چالاکە
    CGRect enemyBox = CGRectMake(rect.size.width / 2 - 50, rect.size.height / 2 - 100, 100, 200);
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextStrokeRect(context, enemyBox);
    
    // کێشانی هێڵ بۆ ناوەڕاستی چوارگۆشەکە (Line ESP)
    CGContextMoveToPoint(context, rect.size.width / 2, 0);
    CGContextAddLineToPoint(context, rect.size.width / 2, rect.size.height / 2 - 100);
    CGContextStrokePath(context);
}
@end

// --- [2] سیستەمی Anti-Ban و چالاککەر ---
__attribute__((constructor))
static void start_esp_system() {
    // یارییەکە کات دەدات بە مۆبایلەکە تا هەموو شتێک باربکات
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *mainWin = [[UIApplication sharedApplication] keyWindow];
        if (mainWin) {
            KamoESPBox *espLayer = [[KamoESPBox alloc] initWithFrame:mainWin.bounds];
            [mainWin addSubview:espLayer];
            NSLog(@"[KAMO] ESP Box Overlay Activated Successfully!");
        }
    });
}
