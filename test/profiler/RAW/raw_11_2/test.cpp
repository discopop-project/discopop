#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int* arr = new int[N];
    int* x = &(arr[21]);
    *x = 231;
    int z = arr[21];

    delete[] arr;
    return 0;
}
