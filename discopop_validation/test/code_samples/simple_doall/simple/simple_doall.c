#include <stdio.h>

int main(){
    int arr[10];

    for(int i=0; i < 10; i++){
        arr[i] = i;
        arr[i] += 3;
    }

    int x = 3;
    for(int i=0; i < 100000; i++){
        arr[x] = i;
        arr[x] += 3;
    }

}
