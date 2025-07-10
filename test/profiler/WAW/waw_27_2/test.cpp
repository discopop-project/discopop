#include <cstdlib>

void foo(int& a){
    a = 1312;
}

int main(){
    int x;
    x = 123;

    for(int i = 0; i < 100; x = i){
        int z = i + 2;
        foo(x);
        ++i;
    }

    return 0;
}
