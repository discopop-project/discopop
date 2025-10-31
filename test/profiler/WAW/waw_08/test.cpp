int main(){
    int arr[42];
    int* x = &(arr[3]);
    arr[13] = 123;
    *(x+10) = 13212;

    return 0;
}
