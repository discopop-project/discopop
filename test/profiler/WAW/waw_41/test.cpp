#include <cstdlib>

void foo(int& a){
    a = 12;
}

int main(){
    int x = 42;
    foo(x);
    x = 1231;

    return 0;
}
