#include <cstdlib>

int main(){
    int arr[101];

    for(int i = 0; i < 100; ++i){
        arr[i+1] = i+32;
        int z = arr[i]+2;
    }
    return 0;
}
