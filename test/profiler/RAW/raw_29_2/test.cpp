#include <cstdlib>

void foo(int* x){
    int z = *x + 2;
}

int main(){
    int a;
    a = 0;
    for(int i = 0; i < 1000; a += 1){
        i += a;
    }
    int z = a;
    return 0;
}
