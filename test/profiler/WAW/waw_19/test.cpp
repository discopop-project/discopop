#include <cstdlib>

int main(){
    int x = 42;
    x = 1231;
    for(int i = 0; i < 100; ++i){
        for(int j = 0; j < 100; j++){
            x = j;
        }
    }

    return 0;
}
