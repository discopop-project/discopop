#include <cstdlib>

int main(){
    int x;
    x = 123;

    for(int i = 0; (x = i) < 100; x = i){
        int z = i + 2;
        ++i;
    }

    return 0;
}
