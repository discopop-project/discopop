#include <cstdlib>

int main(){
    int N = 0;
    while(N < 100){
        N = rand() % 200;
    }
    int arr[N];
    for(int i = 0; i < 100;){
        int z = arr[i];
        i++;
    }
    return 0;
}
