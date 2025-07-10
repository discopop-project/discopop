#include <cstdlib>


void bar(int& b){
    int y = b + 1;
}

void foo(int& a){
    int z = 2;
    bar(a);
}

int main(){
    int x = 42;
    foo(x);
    x = 141;

    return 0;
}
