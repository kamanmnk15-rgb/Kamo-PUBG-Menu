#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// تاقیکردنەوەی ئەدرێسێکی جیاواز بۆ ئەوەی کراش نەکات
#define CHAMS_OFFSET 0x35DA2C0 

__attribute__((constructor))
static void start() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        uintptr_t base = (uintptr_t)_dyld_get_image_header(0);
        uintptr_t target = base + CHAMS_OFFSET;
        uint32_t patch = 0xD503201F;
        mach_port_t task = mach_task_self();
        vm_protect(task, (vm_address_t)target, 4, FALSE, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
        *(uint32_t *)target = patch;
        vm_protect(task, (vm_address_t)target, 4, FALSE, VM_PROT_READ | VM_PROT_EXECUTE);
    });
}
