#include <cstdlib>

void foo(int& y){
    y = 2;
}

int main(){
    int x = 42;
    x = 1231;
    for(int i = 0; i < 100; ++i){
        foo(x);
    }

    return 0;
}
