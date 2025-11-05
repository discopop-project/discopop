#include <cstdlib>

void foo(int& a){
    int z = a + 2;
}

int main(){
    int x = 42;
    foo(x);
    x = 123;

    return 0;
}
