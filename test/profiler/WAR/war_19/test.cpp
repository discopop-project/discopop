#include <cstdlib>

int main(){
    int x = 42;
    int i = 0;

    i = x;
    for(; i < 100; ++i){
        for(int j = 0; j < 100; j++){
            x = j;
        }
    }

    return 0;
}
