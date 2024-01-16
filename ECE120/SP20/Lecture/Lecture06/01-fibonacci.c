/*
 * ECE120 Fall 2016
 *
 * Program name: fibonacci.c, a Fibonacci printer
 *
 * Description: This program prints the first 20 Fibonacci numbers.
 */

/* The following lines is a preprocessor directive. */
#include <stdio.h>        /* Include C's standard I/O header file.  */

/* 
 * Function: main
 * Description: print 20 Fibonacci numbers
 * Parameters: none (we're ignoring the standard ones to main for now)
 * Return Value: 0, which by convention indicates success
 */

int
main ()
{
    /* variable declarations */
    int A = 1; 
    int B = 1; 
    int C; 
    int D;

    /* Print 20 Fibonacci numbers. */
    for (D = 0; 20 > D; D = D + 1) {
	printf ("%d\n", A);
	C = A + B;
	A = B;
	B = C;
    }

    /* Program finished successfully. */
    return 0;
}

