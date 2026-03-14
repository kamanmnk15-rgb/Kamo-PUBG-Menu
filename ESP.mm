#include <UIKit/UIKit.h>

// ئەمە پێکهاتەی یاریزانەکەیە (شوێنی لە ناو یارییەکە)
struct Vector3 {
    float x, y, z;
};

// کۆدی سەرەکی بۆ کێشانی Box
void drawESPBox(CGRect rect, CGContextRef context) {
    // ڕەنگی چوارگۆشەکە (سوور)
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0); 
    // ئەستووری هێڵەکە
    CGContextSetLineWidth(context, 1.5);
    // کێشانی چوارگۆشەکە
    CGContextStrokeRect(context, rect);
}

// ئەم بەشە Loop دەدات بەسەر هەموو یاریزانەکاندا
void updateESP() {
    for (int i = 0; i < max_players; i++) {
        // لێرەدا ئۆفسێتەکان بەکاردێن بۆ دۆزینەوەی شوێنی دوژمن
        Vector3 enemyPos = GetEntityPos(i); 
        
        // گۆڕینی شوێنی ناو یاری بۆ سەر شاشەی مۆبایلەکە
        CGPoint screenPos = WorldToScreen(enemyPos);
        
        if (isOnScreen(screenPos)) {
            // دیاریکردنی قەبارەی Box بەپێی دووری
            float height = 1000 / GetDistance(enemyPos); 
            float width = height / 2;
            
            CGRect boxRect = CGRectMake(screenPos.x - width/2, screenPos.y, width, height);
            
            // بانگکردنی فەرمانی کێشان
            drawESPBox(boxRect, UIGraphicsGetCurrentContext());
        }
    }
}
