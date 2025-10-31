#include <cstdlib>

int main(){
    int N = 101;
    int* arr = new int[N];
    for(int i = 0; i < N; ++i){
        arr[i] = 0;
    }
    int* y = &(arr[39]);
    int* x = &(arr[42]);

    int z = *(y+3);
    *x = 4123;

    delete[] arr;
    return 0;
}
