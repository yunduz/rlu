#include <stdlib.h>
#include <stdio.h>

#include "hash-list-with-lock.h"

int main()
{
  printf("main in bench-lock\n");

  list_l *p_lst = w_lock_new_list();
  printf("size of the list: %d\n", w_lock_list_size(p_lst));

  printf("Added an item to linked list: %d\n", w_lock_list_add(p_lst, 100));
  printf("size of the list: %d\n", w_lock_list_size(p_lst));
  printf("Linked list contains 100: %d\n", w_lock_list_contains(p_lst, 100));
  printf("Linked list contains 200: %d\n", w_lock_list_contains(p_lst, 200));
  printf("Removed an item from linked list: %d\n", w_lock_list_remove(p_lst, 100));
  printf("size of the list: %d\n", w_lock_list_size(p_lst));

  print_w_lock_list(p_lst);

  hash_list_l *p_h_lst = w_lock_new_hash_list(1);
  printf("size of the hash list: %d\n", w_lock_hash_list_size(p_h_lst));

  printf("Added an item to hash list: %d\n", w_lock_hash_list_add(p_h_lst, 101));
  printf("size of the hash list: %d\n", w_lock_hash_list_size(p_h_lst));
  printf("Hash list contains 101: %d\n", w_lock_hash_list_contains(p_h_lst, 101));
  printf("Hash list contains 200: %d\n", w_lock_hash_list_contains(p_h_lst, 200));
  printf("Removed an item from hash list: %d\n", w_lock_hash_list_remove(p_h_lst, 101));
  printf("size of the hash list: %d\n", w_lock_hash_list_size(p_h_lst));

  return 0;
}
