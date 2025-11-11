#include <cstdlib>

int main(){
    int* arr = new int[100];
    int* x = &(arr[42]);
    arr[42] = 412;
    *x = 1231;

    delete[] arr;
    return 0;
}
