#include <cstdlib>

void foo(int& a){
    a = 12;
    a = 131;
}

int main(){
    int x = 42;
    foo(x);

    return 0;
}
