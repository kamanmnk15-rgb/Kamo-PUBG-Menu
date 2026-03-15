#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <rd_route.h> // ئەگەر ڕێگەی پێ بدات بۆ پاتچکردن

// لێرەدا ئۆفسێتی ڕادار دادەنێین کاتێک دۆزیمانەوە
// نموونە: 0x1234567
#define kRadarOffset 0x0 

void patchUAV() {
    uintptr_t address = _dyld_get_image_header(0) + kRadarOffset;
    if (address > 0) {
        // ئەم کۆدە میمۆری دەگۆڕێت بۆ ئەوەی ڕادار هەمیشە ئۆن بێت
        mach_port_t self = mach_task_self();
        vm_protect(self, (vm_address_t)address, 4, FALSE, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
        *(uint32_t *)address = 0xD503201F; // کۆدی NOP (بۆ تێپەڕاندنی مەرجی UAV)
        vm_protect(self, (vm_address_t)address, 4, FALSE, VM_PROT_READ | VM_PROT_EXECUTE);
        NSLog(@"KAMO: UAV Activated ✅");
    }
}

@interface KamoUAV : NSObject
@end

@implementation KamoUAV
+ (void)load {
    // دوای ١٥ چرکە لە ناو یاری چالاک دەبێت
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        patchUAV();
    });
}
@end
