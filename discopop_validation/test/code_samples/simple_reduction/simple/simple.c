#include <stdio.h>

int main(){
    int x = 3;
    int y = 2;
    int arr[10];

    for(int i=0; i < 100000; i++){
        x += i;  // reduction -> no dr
    } 

    for(int i=0; i < 100000; i++){
        x += i;  // no reduction -> dr
    } 

    for(int i=0; i < 100000; i++){
        x += i;  // reduction
        x = 3;  // -> dr
    } 


    for(int i=0; i < 100000; i++){
        y += i;  // reduction  -> no dr.
        x += i;  // reduction  -> no dr.
    }
    
    
    for(int i=0; i < 100000; i++){
        y += i; // reduction
        x += i; // reduction
        x = 3; // -> dr
        arr[i % 10] = i; 
    }

}
