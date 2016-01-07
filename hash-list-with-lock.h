// #include "hash-list.h"

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <limits.h>

/////////////////////////////////////////////////////////
// DEFINES
/////////////////////////////////////////////////////////
#define LIST_VAL_MIN (INT_MIN)
#define LIST_VAL_MAX (INT_MAX)

#define NODE_PADDING (16)

#define MAX_BUCKETS (20000)

/////////////////////////////////////////////////////////
// TYPES
/////////////////////////////////////////////////////////
typedef intptr_t val_t;

typedef struct node_with_lock node_l;
typedef struct node_with_lock {
	val_t val;
	node_l *p_next;
  pthread_mutex_t lock;

	long padding[NODE_PADDING];
} node_l;

typedef struct list_with_locks {
	node_l *p_head;
} list_l;

typedef struct hash_list_with_locks {
	int n_buckets;
	list_l *buckets[MAX_BUCKETS];
} hash_list_l;

/////////////////////////////////////////////////////////
// INTERFACE
/////////////////////////////////////////////////////////
list_l *w_lock_new_list();
int w_lock_list_size(list_l *p_list);
void print_w_lock_list(list_l *p_list);
int w_lock_list_contains(list_l *p_list, val_t val);
int w_lock_list_add(list_l *p_list, val_t val);
int w_lock_list_remove(list_l *p_list, val_t val);

hash_list_l *w_lock_new_hash_list(int n_buckets);

int w_lock_hash_list_size(hash_list_l *p_hash_list);

int w_lock_hash_list_contains(hash_list_l *p_hash_list, val_t val);
int w_lock_hash_list_add(hash_list_l *p_hash_list, val_t val);
int w_lock_hash_list_remove(hash_list_l *p_hash_list, val_t val);
