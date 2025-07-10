int main(){
    int arr[42];
    int* x = &(arr[3]);
    int* y = &(arr[13]);
    *(x+10) = 1321;
    *y = 212;

    return 0;
}
