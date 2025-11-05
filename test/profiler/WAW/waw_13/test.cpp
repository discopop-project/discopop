#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int arr[N];
    int* x = &(arr[13]);

    arr[16] = 141;
    *(x+3) = 1341;

    return 0;
}
