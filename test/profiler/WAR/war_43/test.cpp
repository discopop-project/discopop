#include <cstdlib>


void bar(int& b){
    b = 321;
}

void foo(int& a){
    int z = a + 2;
    bar(a);
}

int main(){
    int x = 42;
    foo(x);

    return 0;
}
