#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// --- ئۆفسێتە سەرەتاییەکان بۆ R6 Mobile ---
uintptr_t kBaseAddr = 0;
uintptr_t kViewMatrixOffset = 0x51A2B30; // پێشبینیکراو بۆ وەشانی نوێ

struct Vector3 { float x, y, z; };
struct Matrix4x4 { float m[16]; };

@interface KamoFinalWinner : UIView
@end

@implementation KamoFinalWinner
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        kBaseAddr = (uintptr_t)_dyld_get_image_header(0);
        [[CADisplayLink displayLinkWithTarget:self selector:@selector(update)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)update { [self setNeedsDisplay]; }

// فەنکشنی WorldToScreen بۆ گۆڕینی 3D بۆ سەر شاشە
bool WorldToScreen(struct Vector3 world, CGPoint *screen, struct Matrix4x4 matrix, CGSize sz) {
    float w = matrix.m[3] * world.x + matrix.m[7] * world.y + matrix.m[11] * world.z + matrix.m[15];
    if (w < 0.01f) return false;
    float x = matrix.m[0] * world.x + matrix.m[4] * world.y + matrix.m[8] * world.z + matrix.m[12];
    float y = matrix.m[1] * world.x + matrix.m[5] * world.y + matrix.m[9] * world.z + matrix.m[13];
    screen->x = (sz.width / 2) * (1 + x / w);
    screen->y = (sz.height / 2) * (1 - y / w);
    return true;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // لۆگۆی تایبەت بە خۆت
    [@"KAMO R6 ESP • INJECTED" drawAtPoint:CGPointMake(20, 50) withAttributes:@{NSForegroundColorAttributeName:[UIColor cyanColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];

    // خوێندنەوەی ماتریکس (ئەمە ئەو بەشەیە کە بۆکسەکە دەجوڵێنێت)
    struct Matrix4x4 vMatrix = *(struct Matrix4x4*)(kBaseAddr + kViewMatrixOffset);
    
    // نموونەی بۆکسێکی تاقیکاری (دوژمن)
    // ئەگەر ئۆفسێتی EntityListـت دەستکەوت، لێرەدا Loop دادەنێین
    struct Vector3 enemyPos = {5, 2, 10}; 
    CGPoint screenPos;
    
    if (WorldToScreen(enemyPos, &screenPos, vMatrix, rect.size)) {
        CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextSetLineWidth(ctx, 2.0);
        
        float boxH = 500 / enemyPos.z; // بەرزی بۆکسەکە بە پێی دووری
        float boxW = boxH / 1.5;
        
        // کێشانی چوارگۆشەکە
        CGRect boxRect = CGRectMake(screenPos.x - boxW/2, screenPos.y - boxH/2, boxW, boxH);
        CGContextStrokeRect(ctx, boxRect);
        
        // خەتێک لە خوارەوە بۆ بۆکسەکە (Snapline)
        CGContextMoveToPoint(ctx, rect.size.width/2, rect.size.height);
        CGContextAddLineToPoint(ctx, screenPos.x, screenPos.y + boxH/2);
        CGContextStrokePath(ctx);
    }
}
@end
