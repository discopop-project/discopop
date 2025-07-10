#include <cstdlib>

int main(){
    int x;
    x = 123;

    for(int i = 0; i < 100; ++i){
        x = i + 2;
        for(int j = 0; j < 100; j++){
            x = i * 21;
        }
    }

    return 0;
}
