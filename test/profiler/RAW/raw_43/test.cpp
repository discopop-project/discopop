#include <cstdlib>

void foo(int& x){
    x = 42 + (rand() % 100);
    int z = x + 2;
}

int main(){
    int a = 42;
    foo(a);

    return 0;
}
