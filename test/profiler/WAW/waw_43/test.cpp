#include <cstdlib>

void bar(int& b){
    b = 1231;
}

void foo(int& a){
    a = 12;
    bar(a);
}

int main(){
    int x = 42;
    foo(x);

    return 0;
}
