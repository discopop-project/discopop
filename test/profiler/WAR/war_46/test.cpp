#include <cstdlib>


void bar_1(int& b){
    int y = b + 1;
}

void foo_1(int& a){
    int z = 2;
    bar_1(a);
}

void bar_2(int& b){
    b = 2412;
}

void foo_2(int& a){
    bar_2(a);
}

int main(){
    int x = 42;
    foo_1(x);
    foo_2(x);

    return 0;
}
