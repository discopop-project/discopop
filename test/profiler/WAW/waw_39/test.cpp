#include <cstdlib>

int main(){
    int arr[101];
    for(int i = 0; i < 101; i++){
        arr[i] = 0;
    }
    for(int i = 0; i < 100; ++i){
        arr[99-(i+1)] = i*2;
        arr[99-i] = 41 + i;
    }

    return 0;
}
