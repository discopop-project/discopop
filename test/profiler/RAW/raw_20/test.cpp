#include <cstdlib>

int main(){
    int arr[42];
    arr[13] = 32;
    for(int i = 0; i < 1000; i += 1){
        for(int j = 0; j < i; j++){
            int z = i + arr[13];
        }
    }
    return 0;
}
