#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int arr[N];
    int& x = arr[17];
    int* y = &(arr[2]);
    *(y+15) = 121;
    int z = x;

    return 0;
}
