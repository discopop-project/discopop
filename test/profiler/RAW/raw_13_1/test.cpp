#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int arr[N];
    arr[17] = 2141 + N;
    int* y = &(arr[2]);
    int z = *(y+15);

    return 0;
}
