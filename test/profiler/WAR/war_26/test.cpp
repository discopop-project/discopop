#include <cstdlib>

void foo(int a){
    a = 1421;
}

int main(){
    int arr[42];
    arr[17] = 4212;
    int i = 0;

    i = arr[17];
    for(i=0; i < 100; ++i){
        foo(arr[17] = i);
    }

    return 0;
}
