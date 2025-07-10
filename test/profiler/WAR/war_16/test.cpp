#include <cstdlib>

int main(){
    int x = 42;
    int i = 0;

    i = x;
    for(; (x = i) < 100; i++){
        int z = i;
    }

    return 0;
}
