#include <cstdlib>

void foo(int& a){
    a = 1312;
}

int main(){
    int arr[101];
    arr[42] = 123;

    int z = 0;
    for(int i = 0; i < 100; arr[42] = i){
        z = i + 2;
        ++i;
    }
    arr[42] = 7;

    return 0;
}
