#include <cstdlib>

int main(){
    int x = 4212;
    for(int i = 0; i < 100; ++i){
        int z = x;
        x = i+2;
    }


    return 0;
}
