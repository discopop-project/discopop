#include <cstdlib>
void foo(int* x){
    int z = 12 + *x;
}

int main(){
    int arr[42];
    arr[13] = 32;
    for(int i = 0; i < 1000; i += 1){
        foo(arr+13);
    }
    return 0;
}
