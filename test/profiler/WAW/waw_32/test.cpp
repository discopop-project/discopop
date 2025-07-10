#include <cstdlib>

void foo(int& a){
    a = 1231;
}

int main(){
    int x;
    x = 123;

    for(int i = 0; i < 100; ++i){
        x = i + 2;
        foo(x);
    }

    return 0;
}
