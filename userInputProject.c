#include <stdio.h>
#include <ctype.h>
#include <regex.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <limits.h>
#include <stdbool.h>

//Used to keep track if overflow error.
int isError = -1;

/**Gives user information on a specific command and how to use it.*/
void info(char input[])
{
    //Checks what command the user wanted info on and prints the data.
    if (strcmp(input, "help") == 0)
    {
        printf("Lists all commands to the user.");
    }
    else if (strcmp(input, "info") == 0)
    {
        printf("Get information on a specific command.");
        printf("\nExample: \"info exit\".");
    }
    else if (strcmp(input, "exit") == 0)
    {
        printf("Terminates the program.");
    }
    else if (strcmp(input, "add") == 0)
    {
        printf("Takes two 32-bit integer values and performs addition on them.");
        printf("\nExample: \"add 5 10\" which would equal 15.");
    }
    else if (strcmp(input, "sub") == 0)
    {
        printf("Takes two 32-bit integer values and subtracts the secound value from the first value.");
        printf("\nExample: \"sub 15 2\" which would equal 13.");
    }
    else if (strcmp(input, "exponent") == 0)
    {
        printf("Takes two 32-bit integer values where the secound value is the exponent and the first value is the base.");
        printf("\nExample: \"exponent 2 8\" which would equal 256.");
    }
    else if (strcmp(input, "divide") == 0)
    {
        printf("Takes two 32-bit integer values and divides the first value by the secound value.");
        printf("\nIt is important to note that in this implementation, the remainder is floored");
        printf("\nExample: \"divide 15 2\" which would equal 7.");
    }
    else if (strcmp(input, "bitcount") == 0)
    {
        printf("Takes a single 32-bit decimal integer value and counts the number of ones in the binaray representation of the value.");
        printf("\nExample: \"bitcount 11\" where the binary representation of 11 being 1011 which would results in a answer of 3.");
    }
    else if (strcmp(input, "summation") == 0)
    {
        printf("Takes two 32-bit integer values and adds all values between the two values (inclusive with boundaries).");
        printf("\nExample: \"summation -2 3\" which equals -2-1+0+1+2+3 = 1");
        printf("\nNote: It does not matter the order of the values, as any pair of numbers will yield same result whether no matter what operand they are.");
    }
    else if (strcmp(input, "factorial") == 0)
    {
        printf("Takes a single 32-bit integer value and performs factorial on the value.");
        printf("\nExample: \"factorial 5\" which would equal 5x4x3x2x1 = 120.");
        printf("\nNote 1: Factorial of 0 factorial is equaivalent to 1.");
        printf("\nNote 2: Negative values are not permitted.");
    }
    else if (strcmp(input, "test") == 0)
    {
        printf("Tests all math commands and prints to the user to see if they are working as intented.");
    }
    else
    {
        printf("Unknown command. Type the command \"help\" for full calculator functionallity");
    }
}

/**Lists all commands to the user when help command is entered by user.*/
void help()
{
    printf("Here is a list of the commands that can be used within this program:");
    printf("\nhelp \ninfo \ntest \nexit \nadd \nsub \nexponent \ndivide \nbitcount \nsummation \nfactorial");
}

void test()
{
    printf("All tests are done using decimal values (Bitcount input is binary input, but decimal output).");

    //Tests addition
    printf("\n100 + 199 = ");
    twoOpParse("add", 100, 199);

    //Tests subtraction
    printf("\n211999 - 9876 = ");
    twoOpParse("sub", 211999, 9876);

    //Tests exponent
    printf("\n5 ^ 5 = ");
    twoOpParse("exponent", 5, 5);

    //Tests floor division
    printf("\n2004 / 5 = ");
    twoOpParse("divide", 2004, 5);

    //Tests bitcount
    printf("\nBitcount of 0b100101010001011110011 = ");
    oneOpParse("bitcount", 0b100101010001011110011);

    //Tests summation
    printf("\nSummation of 10 to 100 = ");
    twoOpParse("summation", 10, 100);

    //Tests factorial
    printf("\n6! = ");
    oneOpParse("factorial", 6);
}

/**Prints result to the user.*/
void printResult(int result)
{
    printf("%i", result);
}

/**Checks what the command is for commands that reuqire no values.*/
void zeroOpParse(char *command)
{
    if (strcmp(command, "exit") == 0)
    {
        return;
    }
    if (strcmp(command, "help") == 0)
    {
        help();
    }
    else if (strcmp(command, "test") == 0)
    {
        test();
    }
    else
    {
        printf("Unknown command. Type the command \"help\" for full calculator functionallity.");
    }
}

/**Takes a char array and determines what command it is, then give that repective assembly procedure the value*/
void oneOpParse(char command[], int value)
{
    if (strcmp(command, "factorial") == 0)
    {

        int result = factorial(value);

        //Prevents user from entering negative value into function.
        //factorial function returns negative value to notify of this error.
        if (result < 0 && isError < 0)
        {
            printf("Negative values are not defined in factorial functions.");
        }
        else if (isError < 0)
        {
            printResult(result);
        }
    }
    else if (strcmp(command, "bitcount") == 0)
    {
        printResult(bitcount(value));
    }
    else
    {
        printf("Unknown command. Type the command \"help\" for full calculator functionallity.");
    }
}

void twoOpParse(char command[], int value1, int value2)
{

    int result;

    if (strcmp(command, "add") == 0)
    {

        result = add(value1, value2);

        if (isError < 0)
        {
            printResult(result);
        }
    }
    else if (strcmp(command, "sub") == 0)
    {
        result = sub(value1, value2);

        if (isError < 0)
        {
            printResult(result);
        }
    }
    else if (strcmp(command, "exponent") == 0)
    {

        result = exponent(value1, value2);

        if (isError < 0)
        {
            printResult(result);
        }
    }
    else if (strcmp(command, "multiply") == 0)
    {
        result = multiply(value1, value2);

        if (isError < 0)
        {
            printResult(result);
        }
    }
    else if (strcmp(command, "divide") == 0)
    {

        result = divide(value1, value2);

        if (isError < 0)
        {
            printResult(result);
        }
    }
    //Sums two values together, direction is decided by assembly program.
    else if (strcmp(command, "summation") == 0)
    {
        result = summation(value1, value2);

        if (isError < 0)
        {
            printResult(result);
        }
    }
    else
    {
        printf("Unknown command. Type the command \"help\" for full calculator functionallity.");
    }
}

void printOverflow()
{
    printf("Integer overflow has occured.");
    //Resets is error to false.
    isError = 1;
}

void printUnderflow()
{
    printf("Integer underflow has occured.");
    //Resets is error to false.
    isError = 1;
}

void divideError()
{
    printf("Dividing by zero is undefined.");
    //Resets is error to false.
    isError = 1;
}

void exponentError()
{
    printf("0 to the power of 0 is undefined.");
    //Resets is error to false.
    isError = 1;
}

int main(void)
{
    //Introduces user to program and gives some basic information on how to get started.
    printf("\nWelcome to Pandora's Box Calculator which is run on weird magic.");
    printf("\nEnter input on lines starting with \">\"");
    printf("\nTo get a list of possible commands type \"help\" or \"info [command name]\" to get information on a specific command.");

    int ARRAY_SIZE = 50;
    char input[ARRAY_SIZE];

    //Keeps track of keyword to terminate program.
    char keyword[] = "exit";
    //Stores the command from user input.
    char command[15];

    //Used to hold user input string with \n character.
    char *temp;

    //Stores arguements for commands.
    char value1[20];
    char value2[20];

    //Used to check if the inputed values are too large for integer to hold.
    long long long1;
    long long long2;

    //Used to make sure the inputed operands are only numbers in the string.
    char *end1;
    char *end2;

    //Keep the program running until user specifies to terminate program.
    while (strcmp(command, keyword) != 0)
    {

        //Resets value.
        isError = -1;

        //Prompt for user to enter information.
        printf("\n\n> ");
        fgets(input, sizeof(input), stdin);
        //temp = toLowerCase(input);
        char *temp = strtok(input, "\n");

        //Do nothing if nothing is typed as string
        if (temp == NULL)
        {
        }
        //If too many arguements, dont even try to parse command.
        else if (sscanf(temp, "%s %s %s %s", command, value1, value2, end1) == 4)
        {
            printf("Unknown command. Type the command \"help\" for full calculator functionallity.");
        }
        //Checks for commands for command and two integer operands.
        else if (sscanf(temp, "%s %s %s", command, value1, value2) == 3)
        {

            //Extract value from strings
            long1 = strtoll(value1, &end1, 10);
            long2 = strtoll(value2, &end2, 10);

            //If one of the operands is not a number, tell user.
            if (*end1 != '\0' || *end2 != '\0')
            {
                printf("One or more invalid operand.");
            }

            //Checks if first value is to large or small to be held as int.
            else if (long1 > INT_MAX || long1 < INT_MIN)
            {
                printf("First inputed value cannot be held as 32-bit value.");
            }
            //Checks if second value is to large or small to be held as int.
            else if (long2 > INT_MAX || long2 < INT_MIN)
            {
                printf("Second inputed value cannot be held as 32-bit value.");
            }
            //Parse the command
            else
            {
                twoOpParse(command, (int)long1, (int)long2);
            }
        }
        //Parses as a command and either and info command or integer operand.
        else if (sscanf(temp, "%s %s", command, value1) == 2)
        {
            //If command is info, parse command as info command
            if (strcmp(command, "info") == 0)
            {
                info(value1);
            }
            //Else parse as secound string as number.
            else
            {
                //Extract value from string.
                long1 = strtoll(value1, &end1, 10);

                //If operand is not number, tell user.
                if (*end1 != '\0')
                {
                    printf("Invalid operand.");
                }
                //Checks if first value is to large or small to be held as int.
                else if (long1 > INT_MAX || long1 < INT_MIN)
                {
                    printf("Inputed value cannot be held as 32-bit value.");
                }
                //Parse command normally.
                else
                {
                    oneOpParse(command, (int)long1);
                }
            }
        }
        //Parse as a zero op command.
        else if (sscanf(temp, "%s", command) == 1)
        {
            zeroOpParse(command);
        }
    }

   
    printf("Program is now terminated.\n");

    return 0;
}
