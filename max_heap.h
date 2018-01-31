void init_heap();           
void insert_to_heap(struct proc* p);
void heapify();
struct proc* pop();
void show_heap();

static struct proc* min_heap[NPROC];