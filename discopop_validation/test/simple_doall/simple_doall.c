#include <stdio.h>

int main(){
    int arr[10];

    for(int i=0; i < 10; i++){
        arr[i] = i;
        arr[i] = arr[i] + 3;
    }

    int x = 42;
    for(int i=0; i < 10; i++){
        arr[x] = i;
        arr[x] = arr[x] + 3;
    }

}
