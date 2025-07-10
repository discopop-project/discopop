#include <cstdlib>

int main(){
    int x = 42;
    int i = 0;

    i = x;
    for(; i < 100; x = i){
        int z = i;
        i++;
    }

    return 0;
}
