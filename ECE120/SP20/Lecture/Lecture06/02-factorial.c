/*
 * ECE120 Fall 2016 (based on ECE190 code from 2005)
 *
 * Program name: factorial.c, a factorial calculator
 *
 * Description: This program asks for an integer, then calculates and
 *              prints the factorial of the number.
 */

/* The following lines is a preprocessor directive. */
#include <stdio.h>        /* Include C's standard I/O header file.  */

/* 
 * Function: main
 * Description: prompt player for a number, then calculate factorial of
 *              that number
 * Parameters: none (we're ignoring the standard ones to main for now)
 * Return Value: 0, which by convention indicates success
 */

int
main ()
{
    /* variable declarations */
    int number;      /* number given by user       */
    int factorial;   /* factorial of user's number */

    /* Print a welcome message, followed by a blank line. */
    printf (">--- Welcome to the factorial calculator! ---<\n\n");

    /* Ask for and read the player's number into a variable. */
    printf ("What factorial shall I calculate for you today? ");
    if (1 != scanf ("%d", &number)) {
        printf ("Only integers, please.\n");
	return 3; /* Program failed. */
    }

    /* Calculate and report the answer (no overflow checking!). */
    for (factorial = number; 1 < number; number = number - 1) {
	factorial = factorial * (number - 1);
    }
    printf ("\nThe factorial is %d.\n", factorial);

    /* Program finished successfully. */
    return 0;
}

