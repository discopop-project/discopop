#include <cstdlib>

void foo(int a){
    int z = a + 22;
}

int main(){
    int x = 42;
    int i = 0;

    i = x;
    for(; i < 100; ++i){
        foo(x=33);
    }

    return 0;
}
