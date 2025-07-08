#include <cstdlib>
int main(){
    int arr[42];
    arr[13] = 0;
    for(int i = 0; i < 1000; arr[13] += 1){
        int z = i + 21;
        i = arr[13];
    }
    return 0;
}
