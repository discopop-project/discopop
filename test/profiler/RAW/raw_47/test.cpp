#include <cstdlib>

void foo_1(int& x){
    x = 42 + (rand() % 100);
}

void bar_1(int &y){
    foo_1(y);
    int z = 32 + y;
}

void bar_2(int &y){
    int z = 32 + y;
}

void foo_2(int& x){
    int b = 42 + (rand() % 100) + x;
    bar_2(x);
}


int main(){
    int a = 42;
    bar_1(a);
    foo_2(a);

    return 0;
}
