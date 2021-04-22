struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
{
    struct rb_node *rb_node;
    struct vm_area_struct *vma;

    // 在task_struct->vmacache[]中查找，看能否命中。
    vma = vmacache_find(mm, addr)
    if (likely(vma))
        return vma;
    // 找到当前mm的第一个rb_node(红黑树)节点。
    rb_node = mm->mm_rb.rb_node;
    vma = NULL;
    // 遍历当前mm空间的所有rb_node。
    while (rb_node) {
        struct vm_area_struct *tmp;
        // 通过rb_node找到对应的vma
        tmp = rb_entry(rb_node, struct vm_area_struct, vm_rb);

        if (tmp->vm_end > addr) {
            vma = tmp;
            // 找到合适的vma，退出。
            if (tmp->vm_start <= addr)
                break;
            rb_node = rb_node->rb_left;
        } else
            rb_node = rb_node->rb_right;
    }

    // 将当前vma放到vmacache[]中。
    if (vma)
        vmacache_update(addr, vma);
    return vma;
}


struct mm_struct {
    struct vm_area_struct *mmap;        
    // vm_area_struct 形成红黑树根节点
    struct rb_root mm_rb;
    u32 vmacache_seqnum;                   
};

struct vm_area_struct {

    unsigned long vm_start;        
    unsigned long vm_end;       
    struct rb_node vm_rb;
    // 指向对应的 mm_struct
    struct mm_struct *vm_mm;   
}


inline unsigned long
vma_address(struct page *page, struct vm_area_struct *vma)
{
    unsigned long address = __vma_address(page, vma);
    VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
    return address;
}

static inline unsigned long
__vma_address(struct page *page, struct vm_area_struct *vma)
{
    pgoff_t pgoff = page_to_pgoff(page);
    // 根据page->index计算当前vma的偏移地址。
    return vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
}

static inline pgoff_t page_to_pgoff(struct page *page)
{
    if (unlikely(PageHeadHuge(page)))
        return page->index << compound_order(page);
    else
        // page->index表示在一个vma中page的index。
        return page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
}


static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
{
    struct anon_vma *anon_vma;
    pgoff_t pgoff;
    struct anon_vma_chain *avc;
    int ret = SWAP_AGAIN;

    // 由page->mapping找到anon_vma数据结构。
    anon_vma = rmap_walk_anon_lock(page, rwc);
    if (!anon_vma)
        return ret;

    pgoff = page_to_pgoff(page);
    // 遍历anon_vma->rb_root红黑树，取出avc数据结构。
    anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
        // 每个avc数据结构指向每个映射的vma
        struct vm_area_struct *vma = avc->vma;
        unsigned long address = vma_address(page, vma);

        if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
            continue;

        ret = rwc->rmap_one(page, vma, address, rwc->arg);
        if (ret != SWAP_AGAIN)
            break;
        if (rwc->done && rwc->done(page))
            break;
    }
    anon_vma_unlock_read(anon_vma);
    return ret;
}


#define page_to_pfn __page_to_pfn
#define pfn_to_page __pfn_to_page

// pfn减去ARCH_PFN_OFFSET得到page相对于mem_map的偏移。
#define __pfn_to_page(pfn)    (mem_map + ((pfn) - ARCH_PFN_OFFSET))
// page到mem_map的偏移加上ARCH_PFN_OFFSET得到当前page对应的pfn号。
#define __page_to_pfn(page)    ((unsigned long)((page) - mem_map) + \
                 ARCH_PFN_OFFSET)



#define    __phys_to_pfn(paddr)    ((unsigned long)((paddr) >> PAGE_SHIFT))
#define    __pfn_to_phys(pfn)    ((phys_addr_t)(pfn) << PAGE_SHIFT)

#define page_to_phys(page)    (__pfn_to_phys(page_to_pfn(page)))
#define phys_to_page(phys)    (pfn_to_page(__phys_to_pfn(phys)))