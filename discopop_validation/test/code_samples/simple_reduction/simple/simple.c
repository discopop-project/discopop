#include <stdio.h>

int main(){
    int x = 3;
    int y = 2;
    for(int i=0; i < 100000; i++){
        x += i;
        y -= i;
    }

}
