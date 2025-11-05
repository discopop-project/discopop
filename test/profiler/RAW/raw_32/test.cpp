#include <cstdlib>

void foo(int x){
    int z = x + 2;
}

int main(){
    int a = 0;
    for(int i = 0; i < 100; ++i){
        a = i*2;
        foo(a);
    }
    return 0;
}
