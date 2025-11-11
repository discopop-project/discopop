int main(){
    int arr[42];
    int* x = &(arr[7]);
    arr[7] = 121;
    int z = *x;

    return 0;
}
