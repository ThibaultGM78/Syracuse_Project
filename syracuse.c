#include <stdio.h>
#include <stdlib.h>

int max(int a,int b)
{
    return a>b ? a : b;
}
int Unext(int U)
{
    if (U%2 == 0) return U/2;
    else return 3*U+1;
}



int main(int argc, char *argv[])
{
    if(argc != 3) // 3 because the file name is also an argument 
    {
        printf("You must provide two arguments : number and output file name\n");
        exit(0);
    }

    
    int U0 = atoi(argv[1]); //atoi() converts a character string to int, return 0 if string doesn't number
    if (U0 == 0) //means that argv[1] isn't a number or a number equal to 0
    {
        printf("Your first argument must be an int different from 0\n");
        exit(0);
    }

    int n=0;
    int U=U0;
    int altimax=U0;
    int dureealtitude_local=0;
    int dureealtitude=0;

    FILE* file = fopen(argv[2],"w");

    if (file == NULL)
    {
        printf("ERROR : file open error");
        exit(0);
    }
    
    fputs("n Un\n",file);
    
    
    while(U != 1)
    {
    
        fprintf(file,"%d %d\n",n,U);
        U=Unext(U);
        n++;
        altimax=max(altimax,U);
        if (U0<=U) dureealtitude_local++; //dureealtitude equal the maximum of the dureealtitude_locals
        else 
        {
            dureealtitude=max(dureealtitude_local,dureealtitude);
            dureealtitude_local=0;
        }
        
    }

    fprintf(file,"%d 1\n",n);
    fprintf(file,"altimax=%d\n",altimax);
    fprintf(file,"dureevol=%d\n",n);
    fprintf(file,"dureealtitude=%d\n",dureealtitude);
    fclose(file);
    return 1;
}

    