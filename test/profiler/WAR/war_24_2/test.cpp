#include <cstdlib>

void foo(int& a){
    a = 1421;
}

int main(){
    int x = 4212;
    int i = 0;

    i = x;
    for(i=0; i < 100; ++i){
        x = i + 21;
    }

    return 0;
}
