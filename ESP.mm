#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>

// ئەدرێسی یەکەم (ئەگەر ئیشی نەکرد دانەی دووەم تاقی دەکەینەوە)
#define CHAMS_OFFSET 0x367F110 

void applyWall() {
    uintptr_t base = (uintptr_t)_dyld_get_image_header(0);
    uintptr_t target = base + CHAMS_OFFSET;
    
    // کۆدی نۆپ (NOP) بۆ وەستاندنی ڕەنگە ئەسڵییەکە و دەرکەوتنی سێبەرەکە
    uint32_t patch = 0xD503201F; 

    mach_port_t task = mach_task_self();
    vm_protect(task, (vm_address_t)target, 4, FALSE, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    *(uint32_t *)target = patch;
    vm_protect(task, (vm_address_t)target, 4, FALSE, VM_PROT_READ | VM_PROT_EXECUTE);
}

__attribute__((constructor))
static void init() {
    // بۆ دڵنیایی زیاتر با ٤٠ چرکە بێت تا بە تەواوی دەچیتە ناو نەخشەکە
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        applyWall();
    });
}
