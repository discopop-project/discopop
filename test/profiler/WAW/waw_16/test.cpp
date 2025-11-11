#include <cstdlib>

int main(){
    int x = 42;
    x = 1231;
    for(int i = 0; (x = i) < 100; ++i){
        int z = 12;
    }

    return 0;
}
