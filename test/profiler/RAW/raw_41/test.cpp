#include <cstdlib>

int main(){
    int arr[101];

    for(int i = 100; i > 0; --i){
        arr[i-1] = i+32;
        int offset = ((rand() % (i))+2) % (i);
        offset--;
        int z = arr[i-offset]+2;
    }
    return 0;
}
