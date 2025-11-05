#include <cstdlib>

int main(){
    int* arr = new int[100];
    int* x = &(arr[42]);
    int& y = arr[49];
    *(x+7) = 1231;
    y = 231;

    delete[] arr;
    return 0;
}
