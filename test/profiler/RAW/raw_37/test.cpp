#include <cstdlib>

int main(){
    int a = 42;
    for(int i = 0; i < 100; ++i){
        a = i+32;
        int z = a+2;
    }
    return 0;
}
