#include <stdio.h>

void write_to_arr(int* p_arr, int i_0, int* p_read_value){
    *(p_arr + i_0) = *p_read_value + i_0;
}


int main(){
    int arr[10];
    int x = 0;
    int y = 0;
    for(int a=0; a < 10; a++){
        int i_0=a;
        arr[i_0] = a + i_0;
        write_to_arr(arr, i_0, &a);
        
        int z = 0;
        if(x > 3){
            arr[i_0] = arr[i_0] + 3;
        }
    }

    if(x > 3){
        y = y + x;
    }
    else{
        y = y - x;
    }

}
