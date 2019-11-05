#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define TRUE 0x0000000000000002L
#define FALSE 0x0000000000000000L

#define BOA_MIN (- (1L << 62))
#define BOA_MAX ((1L << 62) - 1)

extern int64_t our_code_starts_here(int64_t input_val) asm("our_code_starts_here");
extern int64_t print(int64_t input_val) asm("print");
extern int64_t printPrint(int64_t input_val) asm("printPrint");
extern void error(int64_t val) asm("error");

int64_t print(int64_t val) {
  if((val & 1)) {
    printf("%lld\n", (val - 1)/ 2);
  }
  else if(val == 0x0000000000000002) {
    printf("true\n");
  }
  else if(val == 0x0000000000000000) {
    printf("false\n");
  }
  else {
    printf("Unknown value %lld\n", val);
  }
  return 0;
}

int64_t printPrint(int64_t val) {
  if((val & 1)) {
    printf("%lld\n", (val - 1)/ 2);
  }
  else if(val == 0x0000000000000002) {
    printf("true\n");
  }
  else if(val == 0x0000000000000000) {
    printf("false\n");
  }
  else {
    printf("Unknown value %lld\n", val);
  }
  return val;
}

void error(int64_t error_code) {
  // FILL IN YOUR CODE FROM HERE
  if(error_code == 11){ //11: expected a number
    fprintf(stderr, "expected a number");
  }
  else if (error_code == 21){
    fprintf(stderr, "expected a boolean"); //21: expected a bool
  }
  else if (error_code == 31){ //31: overflow from op
    fprintf(stderr, "overflow");
  }
  exit(1);
}

int main(int argc, char** argv) {
  int64_t input_val = 0;
  
  if(argc == 2){
    char* input = argv[1];
    
    int j = 0;
    while(j < strlen(input)){
      if((input[j] < '0') || (input[j] > '9')){
        if(input[j] != '-'){
          fprintf(stderr, "input must be a number");
            exit(1);
        }
      }
      ++j;
    }
    input_val = strtol(input,0, 10);
    if(BOA_MAX < input_val || BOA_MIN > input_val){
      fprintf(stderr, "input is not a representable number");
      exit(1);
    }
  }
  input_val = 2 * input_val + 1;

  // YOUR CODE ENDS HERE
  int64_t result = our_code_starts_here(input_val);
  print(result);
  return 0;
}
