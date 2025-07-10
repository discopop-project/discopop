#include <cstdlib>

void foo(int& a){
    int z = a + 2;
}

void bar(int& b){
    b = 321;
}

int main(){
    int x = 42;
    foo(x);
    bar(x);

    return 0;
}
