int main(){
    int arr[42];
    int* x = &(arr[3]);
    int& y = arr[13];
    *(x+10) = 141;
    y = 1241;

    return 0;
}
