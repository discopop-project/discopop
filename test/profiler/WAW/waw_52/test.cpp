#include <cstdlib>

int main(){
    int* arr = new int[100];
    int* x = &(arr[42]);
    arr[49] = 1341;
    *(x+7) = 1231;

    delete[] arr;
    return 0;
}
