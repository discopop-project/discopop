#include <cstdlib>

int main(){
    int arr[42];
    arr[13] = 32;
    for(int i = 0; i < 1000; i += arr[13]){
        int z = i + 2;
    }
    return 0;
}
