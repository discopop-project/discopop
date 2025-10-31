#include <cstdlib>

int main(){

    int z = 0;
    for(int i = 0; i < 100;){
        i = z + 1;
        z = i;
    }

    return 0;
}
