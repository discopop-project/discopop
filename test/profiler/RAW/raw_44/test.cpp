#include <cstdlib>

void bar(int &y){
    int z = 32 + y;
}

void foo(int& x){
    x = 42 + (rand() % 100);
    bar(x);
}

int main(){
    int a = 42;
    foo(a);

    return 0;
}
