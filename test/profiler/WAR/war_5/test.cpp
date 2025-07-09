int main(){
    int arr[42];
    arr[13] = 21;
    int* x = &(arr[13]);

    int z = arr[13];
    *x = 1337;
    return 0;
}
