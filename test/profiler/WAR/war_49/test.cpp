#include <cstdlib>

int main(){
    int N = 0;
    while(N < 25){
        N = rand() % 50;
    }
    int arr[N];

    int z = 0;
    for(int i = 0; i < 100;){
        int y = i;
        z = arr[i];
        i = y + 1;
    }

    return 0;
}
