#include <cstdlib>

void foo(int x){
    int z = x + 2;
}

int main(){
    int arr[42];
    arr[13] = 0;
    for(int i = 0; i < 1000; arr[13] += 1){
        foo(arr[13]);
        i += arr[13];
    }
    return 0;
}
