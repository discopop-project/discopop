int main(){
    int arr[42];
    int* y = &(arr[13]);
    *y = 212;
    arr[13] = 12;

    return 0;
}
