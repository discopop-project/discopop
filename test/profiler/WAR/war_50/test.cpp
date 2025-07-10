#include <cstdlib>

int main(){
    int arr[101];

    int z = 0;
    for(int i = 0; i < 100;){
        int y = i;
        z = arr[i];
        i = y + 1;
    }

    return 0;
}
