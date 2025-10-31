int main(){
    int arr[42];
    arr[13] = 21;
    int* x = &(arr[13]);

    int z = *x;
    arr[13] = 1337;
    return 0;
}
