#include <cstdlib>

void foo(int a){
    int z = a * 2;
}

int main(){
    int x;
    x = 123;

    for(int i = 0; i < 100; ++i){
        x = i + 2;
        foo(x = i * 21);
    }

    return 0;
}
