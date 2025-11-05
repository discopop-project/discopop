#include <cstdlib>

void foo(int& x){
    x = 42 + (rand() % 100);
}

void bar(int &y){
    foo(y);
    int z = 32 + y;
}

int main(){
    int a = 42;
    bar(a);

    return 0;
}
