#include <cstdlib>

void foo(int& a){
    a = 1312;
}

int main(){
    int x;
    x = 123;

    int z = 0;
    for(int i = 0; i < 100; x = i){
        z = i + 2;
        ++i;
    }
    x = 7;

    return 0;
}
