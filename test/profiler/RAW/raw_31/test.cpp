#include <cstdlib>

int main(){
    int a = 0;
    for(int i = 0; i < 100; ++i){
        a = i*2;
        for(int j = 0; j < 10; j++){
            int z = a + 3;
        }
    }
    return 0;
}
