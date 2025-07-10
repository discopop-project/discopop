#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int arr[N];
    int* x = &(arr[13]);
    int* y = &(arr[16]);

    *(x+3) = 131;
    *y = 13124;

    return 0;
}
