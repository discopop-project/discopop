int main(){
    int arr[42];
    arr[19] = 21;
    int* x = &(arr[13]);

    int z = arr[19];
    *(x+6) = 1337;
    return 0;
}
