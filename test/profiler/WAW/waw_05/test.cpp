int main(){
    int arr[42];
    arr[13] = 12;
    int* y = &(arr[13]);
    *y = 212;

    return 0;
}
