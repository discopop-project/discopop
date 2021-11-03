#include "serial-app.h"

#define BOTS_APP_NAME "Knapsack"
#define BOTS_APP_PARAMETERS_DESC "%s"
#define BOTS_APP_PARAMETERS_LIST ,bots_arg_file

#define BOTS_APP_USES_ARG_FILE
#define BOTS_APP_DEF_ARG_FILE "Input filename"
#define BOTS_APP_DESC_ARG_FILE

/* every item in the knapsack has a weight and a value */
#define MAX_ITEMS 256

struct item {
     int value;
     int weight;
};

int compare(struct item *a, struct item *b);
int read_input(const char *filename, struct item *items, int *capacity, int *n);
void knapsack(struct item *e, int c, int n, int v, int *sol);
void knapsack_main (struct item *e, int c, int n, int *sol);

#define BOTS_APP_INIT\
     struct item items[MAX_ITEMS];\
     int n, capacity;\
     int sol = 0;\
     read_input(bots_arg_file, items, &capacity, &n);

#define KERNEL_INIT 
#define KERNEL_CALL knapsack_main(items, capacity, n, &sol);
#define KERNEL_FINI

//#define KERNEL_SEQ_INIT 
//#define KERNEL_SEQ_CALL
//#define KERNEL_SEQ_FINI

#define KERNEL_CHECK BOTS_RESULT_NA

