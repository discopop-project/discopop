#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int* arr = new int[N];
    arr[17] = 2141 + N;
    int* y = &(arr[2]);
    int z = *(y+15);

    delete[] arr;
    return 0;
}
