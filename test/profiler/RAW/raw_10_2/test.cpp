#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int* arr = new int[N];
    int* x = &(arr[21]);
    arr[21] = 1231;
    int z = *x;

    delete[] arr;

    return 0;
}
