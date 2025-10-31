#include <cstdlib>

int main(){
    int N = 101;
    int* arr = new int[N];
    for(int i = 0; i < N; ++i){
        arr[i] = 0;
    }
    int& y = arr[42];

    int z = *(arr+42);
    y = 4123;

    delete[] arr;
    return 0;
}
