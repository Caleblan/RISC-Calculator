//#indef USERINPUTPROJECT_H
//#define USERINPUTPROJECT_H

/**Lists all commands to the user when help command is entered by user.*/
void help();

/**Gives user information on a specific command and how to use it.*/
void info(char input[]);

/**Tests the mathematical command to make sure they work.*/
void test();

/**Prints result to the user.*/
void printResult(int result);

/**Parses command with zero operands. */
void zeroOpParse(char *command);

/**Parses command with one operands. */
void oneOpParse(char command[], int value);

/**Parses command with two operands. */
void twoOpParse(char command[], int value1, int value2);

/**Prints an overflow message and prevent printing of value in parse methods. 
 * Called from Assembly.
*/
void printOverflow();

/**Prints an overflow message and prevent printing of value in parse methods. 
 * Called from Assembly.
*/
void printUnderflow();

/**Prevents # / 0 and prevents value from being printed in parse methods. 
 * Called from Assembly.
*/
void divideError();

/**Prevents 0^0 and prevents value from being printed in parse methods.
 * Called from Assembly.
*/
void exponentError();


//#endif
