#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int arr[N];
    arr[13] = 0;
    int* x = &(arr[13]);

    int z = *x + 2;
    arr[13] = 1337;
    return 0;
}
