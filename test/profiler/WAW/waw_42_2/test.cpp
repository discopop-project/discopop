#include <cstdlib>

void foo(int& a){
    a = 12;
}

void bar(int& b){
    b = 1231;
}

int main(){
    int x = 42;
    foo(x);
    bar(x);

    return 0;
}
