#include <cstdlib>


void bar_1(int& b){
    int y = b + 1;
}

void foo_1(int& a){
    int z = 2;
    bar_1(a);
}

void foo_2(int* a){
    *a = 1441;
}

int main(){
    int x = 42;
    foo_1(x);
    foo_2(&x);

    return 0;
}
