int main(){
    int arr[42];
    int* x = &(arr[7]);
    *x = 1412;
    int z = arr[7];

    return 0;
}
