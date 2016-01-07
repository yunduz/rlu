

#include "hash-list-with-lock.h"

/////////////////////////////////////////////////////////
// DEFINES
/////////////////////////////////////////////////////////
#define HASH_VALUE(p_hash_list, val)       (val % p_hash_list->n_buckets)

/////////////////////////////////////////////////////////
// NEW NODE
/////////////////////////////////////////////////////////
node_l *w_lock_new_node() {

	node_l *p_new_node = (node_l *)malloc(sizeof(node_l));
	if (p_new_node == NULL){
		printf("out of memory\n");
		exit(1);
	}

  if (pthread_mutex_init(&(p_new_node->lock), NULL) != 0)
  {
      printf("\n mutex init failed\n");
      exit(1);
  }

  return p_new_node;
}

/////////////////////////////////////////////////////////
// FREE NODE
/////////////////////////////////////////////////////////
void w_lock_free_node(node_l *p_node) {
	if (p_node != NULL) {
		free(p_node);
	}
}

/////////////////////////////////////////////////////////
// NEW LIST
/////////////////////////////////////////////////////////
list_l *w_lock_new_list()
{
	list_l *p_list;
	node_l *p_min_node, *p_max_node;

	p_list = (list_l *)malloc(sizeof(list_l));
	if (p_list == NULL) {
		perror("malloc");
		exit(1);
	}

	p_max_node = w_lock_new_node();
	p_max_node->val = LIST_VAL_MAX;
	p_max_node->p_next = NULL;

	p_min_node = w_lock_new_node();
	p_min_node->val = LIST_VAL_MIN;
	p_min_node->p_next = p_max_node;

	p_list->p_head = p_min_node;

	return p_list;
}

/////////////////////////////////////////////////////////
// NEW HASH LIST
/////////////////////////////////////////////////////////
hash_list_l *w_lock_new_hash_list(int n_buckets)
{
	int i;
	hash_list_l *p_hash_list;

	p_hash_list = (hash_list_l *)malloc(sizeof(hash_list_l));

	if (p_hash_list == NULL) {
	    perror("malloc");
	    exit(1);
	}

	p_hash_list->n_buckets = n_buckets;

	for (i = 0; i < p_hash_list->n_buckets; i++) {
		p_hash_list->buckets[i] = w_lock_new_list();
	}

	return p_hash_list;
}

/////////////////////////////////////////////////////////
// LIST SIZE
/////////////////////////////////////////////////////////
int w_lock_list_size(list_l *p_list)
{
	int size = 0;
	node_l *p_node;

	/* We have at least 2 elements */
	p_node = p_list->p_head->p_next;
	while (p_node->p_next != NULL) {
		size++;
		p_node = p_node->p_next;
	}

	return size;
}

/////////////////////////////////////////////////////////
// HASH LIST SIZE
/////////////////////////////////////////////////////////
int w_lock_hash_list_size(hash_list_l *p_hash_list)
{
	int i;
	int size = 0;

	for (i = 0; i < p_hash_list->n_buckets; i++) {
		size += w_lock_list_size(p_hash_list->buckets[i]);
	}

	return size;
}

/////////////////////////////////////////////////////////
// LIST PRINT
/////////////////////////////////////////////////////////
void print_w_lock_list(list_l *p_list)
{
	node_l *p_prev, *p_next;

	p_prev = p_list->p_head;
  pthread_mutex_lock(&p_prev->lock);
	p_next = p_prev->p_next;
  pthread_mutex_lock(&p_next->lock);

	while (p_next->val < LIST_VAL_MAX) {
    printf("%ld->", p_next->val);
    pthread_mutex_unlock(&p_prev->lock);
		p_prev = p_next;
		p_next = p_prev->p_next;
    pthread_mutex_lock(&p_next->lock);
	}

  printf("tail\n");

  pthread_mutex_unlock(&p_next->lock);
  pthread_mutex_unlock(&p_prev->lock);

  return;
}

/////////////////////////////////////////////////////////
// LIST ADD
/////////////////////////////////////////////////////////
int w_lock_list_add(list_l *p_list, val_t val)
{
	int result;
	node_l *p_prev, *p_next, *p_new_node;

	p_prev = p_list->p_head;
  pthread_mutex_lock(&p_prev->lock);
	p_next = p_prev->p_next;
  pthread_mutex_lock(&p_next->lock);

	while (p_next->val < val) {
    pthread_mutex_unlock(&p_prev->lock);
		p_prev = p_next;
		p_next = p_prev->p_next;
    pthread_mutex_lock(&p_next->lock);
	}

	result = (p_next->val != val);

	if (result) {
		p_new_node = w_lock_new_node();
		p_new_node->val = val;
		p_new_node->p_next = p_next;

		p_prev->p_next = p_new_node;
	}

  pthread_mutex_unlock(&p_next->lock);
  pthread_mutex_unlock(&p_prev->lock);

	return result;
}

/////////////////////////////////////////////////////////
// HASH LIST ADD
/////////////////////////////////////////////////////////
int w_lock_hash_list_add(hash_list_l *p_hash_list, val_t val)
{
	int hash = HASH_VALUE(p_hash_list, val);

	return w_lock_list_add(p_hash_list->buckets[hash], val);
}

/////////////////////////////////////////////////////////
// LIST CONTAINS
/////////////////////////////////////////////////////////
int w_lock_list_contains(list_l *p_list, val_t val) {
	node_l *p_prev, *p_next;

	p_prev = p_list->p_head;
  pthread_mutex_lock(&p_prev->lock);
	p_next = p_prev->p_next;
  pthread_mutex_lock(&p_next->lock);

	while (p_next->val < val) {
    pthread_mutex_unlock(&p_prev->lock);
		p_prev = p_next;
		p_next = p_prev->p_next;
    pthread_mutex_lock(&p_next->lock);
	}

  pthread_mutex_unlock(&p_next->lock);
  pthread_mutex_unlock(&p_prev->lock);

	return p_next->val == val;
}

/////////////////////////////////////////////////////////
// HASH LIST CONTAINS
/////////////////////////////////////////////////////////
int w_lock_hash_list_contains(hash_list_l *p_hash_list, val_t val)
{
	int hash = HASH_VALUE(p_hash_list, val);

	return w_lock_list_contains(p_hash_list->buckets[hash], val);
}

/////////////////////////////////////////////////////////
// LIST REMOVE
/////////////////////////////////////////////////////////
int w_lock_list_remove(list_l *p_list, val_t val) {
	int result;
	node_l *p_prev, *p_next;

	p_prev = p_list->p_head;
  pthread_mutex_lock(&p_prev->lock);
	p_next = p_prev->p_next;
  pthread_mutex_lock(&p_next->lock);

	while (p_next->val < val) {
    pthread_mutex_unlock(&p_prev->lock);
		p_prev = p_next;
		p_next = p_prev->p_next;
    pthread_mutex_lock(&p_next->lock);
	}

	result = (p_next->val == val);

	if (result) {
		p_prev->p_next = p_next->p_next;
		w_lock_free_node(p_next);
	}

  pthread_mutex_unlock(&p_next->lock);
  pthread_mutex_unlock(&p_prev->lock);

	return result;
}

/////////////////////////////////////////////////////////
// HASH LIST REMOVE
/////////////////////////////////////////////////////////
int w_lock_hash_list_remove(hash_list_l *p_hash_list, val_t val)
{
	int hash = HASH_VALUE(p_hash_list, val);

	return w_lock_list_remove(p_hash_list->buckets[hash], val);
}
