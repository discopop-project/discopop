#include <cstdlib>

void foo(int& a){
    a = 1421;
}

int main(){
    int x = 4212;
    int i = 0;

    i = x;
    for(i=0; i < 100; ++i){
        for(int j = 0; j < 100; ++j){
            x = i + 21;
        }
    }

    return 0;
}
