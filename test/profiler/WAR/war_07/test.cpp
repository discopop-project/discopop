int main(){
    int arr[42];
    arr[19] = 21;
    int* x = &(arr[13]);
    int* y = &(arr[19]);

    int z = *(x+6);
    *y = 1337;
    return 0;
}
