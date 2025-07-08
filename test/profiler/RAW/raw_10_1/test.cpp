#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int arr[N];
    int* x = &(arr[21]);
    arr[21] = 1231;
    int z = *x;

    return 0;
}
