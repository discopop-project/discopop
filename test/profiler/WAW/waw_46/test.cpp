#include <cstdlib>

void bar_1(int& b){
    b = 1231;
}

void foo_1(int& a){
    a = 12;
    bar_1(a);
}

void bar_2(int& d){
    d = 2412;
}

void foo_2(int& c){
    bar_2(c);
}

int main(){
    int x = 42;
    foo_1(x);
    foo_2(x);

    return 0;
}
