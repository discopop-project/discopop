#include <cstdlib>

void foo(int& a){
    a = 1421;
}

int main(){
    int x = 4212;
    int i = 0;

    for(i=0; i < 100; ++i){
        int z = x;
        for(int j = 0; j < 100; j++){
            x = i + z;
        }
    }

    return 0;
}
