#include <stdio.h>

int main(){
    int arr[10];
    int x = 3;
    for(int i=0; i < 100000; i++){
        arr[x] = i;
        arr[x] += 3;
        arr[x] = arr[x] - (arr[x] % 2);
    }

}
