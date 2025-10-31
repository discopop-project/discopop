#include <cstdlib>

void foo(int& a){
    a = 1421;
}

int main(){
    int x = 42;
    int i = 0;

    i = x;
    for(; i < 100; ++i){
        int z = i + 21;
    }
    x = i;

    return 0;
}
