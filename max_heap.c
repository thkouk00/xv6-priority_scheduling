#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "max_heap.h"

// void init_heap();           
// void insert_to_heap(struct proc* p);
// void heapify();
// struct proc* pop();
// void show_heap();

// static struct proc* min_heap[NPROC];


void                                    	// min_heap structure
init_heap()
{
    int i;
    for(i=0;i<NPROC;i++)
    	min_heap[i] = 0;
}

void
insert_to_heap(struct proc* p)				//insertion to heap
{
	int i;
	for (i=0;i<NPROC;i++)
	{
		if (!min_heap[i])
		{
			min_heap[i] = p;
			heapify();
			break;
		}
	}
}

void
heapify()
{
	int i;
  	int y;
  	struct proc* temp;
  	for (y=0;y<NPROC;y++)          
 	{ 
	    for (i=NPROC-1;i>=0;i--)
	    {
	    	if (min_heap[i] && min_heap[i]->priority < min_heap[(i-1)/2]->priority)
	    	{
	    		temp = min_heap[(i-1)/2];
		        min_heap[(i-1)/2] = min_heap[i];
		        min_heap[i] = temp;
	    	}
	    }
	}
}

struct proc*
pop()
{
	int i;
	struct proc* temp_p;
	temp_p = min_heap[0];
	for (i=NPROC-1;i>=0;i--)
	{
		if (min_heap[i])
			break;
	}
	min_heap[0]=min_heap[i];
	min_heap[i] = 0;
	heapify();
	return temp_p;

}

void show_heap()
{
	cprintf("Show heap\n");
	int i;
	for(i=0;i<NPROC;i++)
	{
		if (min_heap[i])
		{
			cprintf("pos %d and min id = %d and name %s\n",i,min_heap[i]->pid,min_heap[i]->name);
			cprintf("p.priority: %d\n",(int)(min_heap[i]->priority*100));
		}
	}
}