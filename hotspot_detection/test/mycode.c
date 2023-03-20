
#include <stdio.h>



void func1(){
    for (int i=0; i<30000 ; i++){
    }
}

void func2(int iter){
    int x = 0;
    int y = 1;
    y++;
    while ( x < iter*948){
        x++;
    }
}

void func3(){
    for (int i=0; i<100 ;){ 
        i++;
        ///
        for (int j=0; j<300 ;){
            j++;
            for (int k=0; k<15000 ;){
                k++;
            }
        }
    }

}



int func4(){
    int temp = 0;
    temp++;
    return temp;
}


void func5(){

    for (int i=0; i<522 ; i++){
       for (int j=0; j<533 ; j++){
         }
    }

}

void func6(int n){
    //call
    if ( n < 1){
        return;
    }
    n--;
    for (int j=0; j<6 ; j++){
    }
    
    func6(n);
}


int main() {
    int x = 5;
    int y;
    y = x + 8;

    for (int k=1; k<9 ;){
        k = k*2;
    }

    
    func1();
    for (int i=0; i<x ; i++){
        func1();

    }
    func2(7);
    func2(10);


    for (int j=0; j<y ; j++){
    }

    printf("mycode main\n");
    func3();

for (int i=0; i<500 ;){ //10
        i++;
        for (int j=0; j<500 ;){//300
            j++;
            //int dd = func4();
            for (int k=0; k<500 ;){//1500
                k++;
            }
            

        }
    }

    int cc = func4();
    func6(5);

    int myi[7]={0};

/*
      
    printf("please enter inputs \n");
	
      for (int ii=0; ii<6 ;ii++){ 
        //errs() << std::stoi(tp) << "\n";
        scanf("%d",&myi[ii]);
        //myi[ii] = std::stoi(tp);
      }
    printf("please wait...\n");


    for (int i=0; i<myi[0] ;i++){ 
        for (int j=0; j<myi[1] ;j++){
            for (int k=0; k<myi[2] ;k++){
            }
        }
    }

    for (int k=0; k<myi[3] ;k++){
        for (int i=0; i<500 ;){ //10
        i++;
        for (int j=0; j<500 ;){//300
            j++;
            //int dd = func4();
            for (int l=0; l<500 ;){//1500
                l++;
            }
            

        }
    }
    }

    for (int k=0; k<myi[4] ;k++){
        for (int i=0; i<500 ;){ //10
        i++;
        for (int j=0; j<500 ;){//300
            j++;
            //int dd = func4();
            for (int l=0; l<500 ;){//1500
                l++;
            }
            

        }
    }
    }

    for (int k=0; k<myi[5] ;k++){
        for (int i=0; i<500 ;){ //10
        i++;
        for (int j=0; j<500 ;){//300
            j++;
            //int dd = func4();
            for (int l=0; l<500 ;){//1500
                l++;
            }
            

        }
    }
    }

    
*/
    return y ;
}


