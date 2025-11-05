#include <cstdlib>

void foo(int& x){
    x = 42 + (rand() % 100);
}

int main(){
    int a = 42;
    foo(a);
    int z = a + 2;

    return 0;
}
