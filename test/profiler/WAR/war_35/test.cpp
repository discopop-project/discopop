#include <cstdlib>

void foo(int& a){
    a = 4221;
}

int main(){
    int x = 4212;

    int z = x;
    foo(x);

    return 0;
}
