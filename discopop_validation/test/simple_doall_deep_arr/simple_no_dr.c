#include <stdio.h>

int main(){
    int arr[10][10][10][10];
    int x = 0;
    int y = 0;
    for(int a=0; a < 10; a++){
        int i_0=a, i_1=(a*2)%10, i_2=(a*3)%10, i_3=(a*4)%10;
        arr[i_0][i_1][i_2][i_3] = a+i_2;
        int z = 0;
        if(x > 3){
            arr[i_0][i_1][i_2][i_3] = arr[i_0][i_1][i_2][i_3] + 3;
        }
    }

    if(x > 3){
        y = y + x;
    }
    else{
        y = y - x;
    }

}
