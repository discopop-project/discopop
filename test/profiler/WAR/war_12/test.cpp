#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int arr[N];
    arr[17] = 0;
    int* x = &(arr[13]);
    int* y = &(arr[17]);

    int z = *(x+4) + 2;
    *y = 1337;
    return 0;
}
