#include <cstdlib>

int main(){
    int* arr = new int[100];
    int* x = &(arr[42]);
    *x = 1231;
    arr[42] = 412;

    delete[] arr;
    return 0;
}
