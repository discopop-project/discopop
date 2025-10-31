#include <cstdlib>

void foo(int& a){
    a = 1421;
}

int main(){
    int arr[42];
    arr[17] = 4212;
    int i = 0;

    i = arr[17];
    for(arr[17] = 51; i < 100; ++i){
        int z = i + 21;
    }

    return 0;
}
