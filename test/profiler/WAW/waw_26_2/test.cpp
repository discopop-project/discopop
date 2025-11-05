#include <cstdlib>

void foo(int a){
    int y = 2*a;
}

int main(){
    int x;
    x = 123;

    for(int i = 0; i < 100; x = i){
        int z = i + 2;
        foo(x = z);
        ++i;
    }

    return 0;
}
