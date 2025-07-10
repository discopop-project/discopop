#include <cstdlib>

void foo(int& a){
    a = 1421;
}

int main(){
    int x = 4212;
    int i = 0;

    i = x;
    for(x = 51; i < 100; ++i){
        int z = i + 21;
    }

    return 0;
}
