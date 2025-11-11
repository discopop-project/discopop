#include <cstdlib>

void foo(int& x){
    x = 42 + (rand() % 100);
}

void bar(int &y){
    int z = 32 + y;
    foo(y);
}

int main(){
    int a = 42;
    foo(a);
    int z = a;

    return 0;
}
