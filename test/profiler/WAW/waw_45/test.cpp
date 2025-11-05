#include <cstdlib>

void bar_1(int& b){
    b = 1231;
}

void foo_1(int& a){
    a = 12;
    bar_1(a);
}

void foo_2(int& c){
    c = 4121;
}

int main(){
    int x = 42;
    foo_1(x);
    foo_2(x);

    return 0;
}
