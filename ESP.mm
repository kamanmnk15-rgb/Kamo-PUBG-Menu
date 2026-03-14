#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// ئەم بەشە بەرپرسە لە کێشانی ESP لەسەر شاشەکە
@interface KamoESPView : UIView
@end

@implementation KamoESPView
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // ڕ
