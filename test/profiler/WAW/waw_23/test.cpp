#include <cstdlib>

int main(){
    int arr[101];
    arr[42] = 123;

    for(int i = 0; (arr[42] = i) < 100; arr[42] = i){
        int z = i + 2;
        ++i;
    }

    return 0;
}
