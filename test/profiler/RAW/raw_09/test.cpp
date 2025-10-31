int main(){
    int arr[42];
    int* x = &(arr[21]);
    int& y = arr[13];
    *(x-8) = 1412;
    int z = y;

    return 0;
}
