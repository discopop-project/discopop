int main(){
    int arr[42];
    arr[24] = 4121;
    int* y = &(arr[13]);
    int z = *(y+11);

    return 0;
}
