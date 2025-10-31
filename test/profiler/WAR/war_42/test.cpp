#include <cstdlib>

void foo(int& a){
    int z = a + 2;
    a = z;
}

int main(){
    int x = 42;
    foo(x);

    return 0;
}
