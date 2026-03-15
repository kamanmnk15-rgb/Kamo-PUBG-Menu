#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// ئەدرێسی پێشنیارکراو بۆ Wallhack/Chams لە ڤێرژنی 1.8.54
// تێبینی: ئەگەر ئەمە ئیش نەکات، واتا یارییەکە ئەدرێسەکەی گۆڕیوە
#define CHAMS_OFFSET 0x367F110 

void enableGreenWall() {
    uintptr_t base = (uintptr_t)_dyld_get_image_header(0);
    uintptr_t target = base + CHAMS_OFFSET;
    
    // کۆدی Patch بۆ تێپەڕاندنی گرافیکی دیوار
    uint32_t patch = 0xD503201F; 

    mach_port_t self = mach_task_self();
    kern_return_t kr = vm_protect(self, (vm_address_t)target, 4, FALSE, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    
    if (kr == KERN_SUCCESS) {
        *(uint32_t *)target = patch;
        vm_protect(self, (vm_address_t)target, 4, FALSE, VM_PROT_READ | VM_PROT_EXECUTE);
        NSLog(@"KAMO: Wallhack applied successfully!");
    } else {
        NSLog(@"KAMO: Failed to patch memory.");
    }
}

@interface KamoLoader : NSObject
@end

@implementation KamoLoader
+ (void)load {
    // دوای ١٥ چرکە لە ناو یاری چالاک دەبێت
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        enableGreenWall();
    });
}
@end
