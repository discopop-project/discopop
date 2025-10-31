#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int arr[N];
    int* y = &(arr[18]);
    int* x = &(arr[11]);
    *(x+7) = 231;
    int z = *y;

    return 0;
}
