#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// تەنها یەک ئەدرێسی سەرەکی تاقی دەکەینەوە بۆ ئەوەی فایلەکە قورس نەبێت
#define UAV_OFFSET 0x34C8A20 

void applyRadar() {
    uintptr_t base = (uintptr_t)_dyld_get_image_header(0);
    uintptr_t address = base + UAV_OFFSET;
    
    unsigned char patch[] = {0x1F, 0x20, 0x03, 0xD5}; // کۆدی NOP بە شێوەی بایتی سادە
    
    mach_port_t task = mach_task_self();
    vm_protect(task, (vm_address_t)address, 4, FALSE, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    memcpy((void *)address, patch, 4);
    vm_protect(task, (vm_address_t)address, 4, FALSE, VM_PROT_READ | VM_PROT_EXECUTE);
}

__attribute__((constructor))
static void initialize() {
    // دوای ١٥ چرکە ئیش بکات بۆ ئەوەی یارییەکە Crash نەکات لە کاتی کردنەوە
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        applyRadar();
    });
}
