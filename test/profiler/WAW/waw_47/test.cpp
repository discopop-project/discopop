#include <cstdlib>

int main(){
    int x = 42;
    for(int i = 0; i < 100; x = (i = (x = i))){
        int z = i + 2;
        i++;
    }

    return 0;
}
