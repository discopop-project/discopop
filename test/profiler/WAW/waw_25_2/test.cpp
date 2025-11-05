#include <cstdlib>

int main(){
    int x;
    x = 123;

    for(int i = 0; i < 100; x = i){
        int z = i + 2;
        for(int j = 0; j < 100; j++){
            x = j;
        }
        ++i;
    }

    return 0;
}
