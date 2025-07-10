#include <cstdlib>

void foo(int& a){
    a = 1312;
}

int main(){
    int arr[101];
    arr[42] = 123;

    for(int i = 0; i < 100; arr[42] = i){
        int z = i + 2;
        foo(arr[42]);
        ++i;
    }

    return 0;
}
