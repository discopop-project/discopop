#include <cstdlib>

void foo(int y){
    int z = y + 2;
}

int main(){
    int x = 42;
    x = 1231;
    for(int i = 0; i < 100; ++i){
        foo(x = i);
    }

    return 0;
}
