#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int arr[N];
    int* x = &(arr[13]);

    *x = 131;
    arr[13] = 13124;

    return 0;
}
