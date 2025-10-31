#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int arr[N];
    int* y = &(arr[13]);
    arr[13] = 131;
    *y = 1431;

    return 0;
}
