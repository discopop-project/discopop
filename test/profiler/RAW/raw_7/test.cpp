int main(){
    int arr[42];
    int* x = &(arr[7]);
    int* y = &(arr[28]);
    *(x+21) = 1412;
    int z = *y;

    return 0;
}
