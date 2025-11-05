#include <cstdlib>

void foo(int& a){
    a = 1231;
}

int main(){
    int x;
    x = 123;
    foo(x);

    return 0;
}
