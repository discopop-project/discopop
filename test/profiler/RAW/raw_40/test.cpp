#include <cstdlib>

int main(){
    int arr[101];

    for(int i = 100; i > 2; --i){
        arr[i-2] = i+32;
        int z = arr[i-1]+2;
    }
    return 0;
}
