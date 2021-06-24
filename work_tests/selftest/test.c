#include <stdio.h>

int addition(int a, int b){
    return a + b;
}

int main(){
    int A[50];
    int a = 25;
    if (a == 20){
        for(int i = 0; i < 50; i++) {
            A[i] = 1+i;
        }
    }
    else {
        for(int i = 0; i < 50; i++) {
            A[i] = 2*i;
        }
    }

    int B[20];
    for (int i = 0; i<20; i++){
        B[i] = i + 1;
        if (i > 25){
            for (int j = 1; j <= i; j++){
                B[i] += j;
            }
        }
    }
    printf("succesful");
    
}


