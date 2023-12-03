#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#define PART_TWO false

typedef char *Line;

Line readLine(FILE *input_file, bool *endOfFile)
{
    unsigned int line_length = 0;
    Line currentLine = malloc(100 * sizeof(char));
    char letter = 0;
    while (letter != EOF)
    {
        letter = fgetc(input_file);
        if (letter == '\n')
        {
            break;
        }

        if (line_length % 100 == 0)
        {
            currentLine = realloc(currentLine, (line_length + 100) * sizeof(char));
            if (currentLine == NULL)
            {
                printf("Error allocating memory\n");
                return NULL;
            }
        }
        currentLine[line_length] = letter;
        line_length++;
    }
    currentLine = realloc(currentLine, (line_length + 1) * sizeof(char));
    currentLine[line_length] = '\0';
    if (line_length == 1)
    {
        *endOfFile = letter == EOF;
    }
    return currentLine;
}
bool isNumber(char letter)
{
    if (letter >= 48 && letter <= 57)
    {
        return true;
    }
    return false;
}
bool isSymbol(char letter)
{
    if (letter != '.' && isNumber(letter) == false)
    {
        return true;
    }
    return false;
}

int isGear(char letter, int id)
{
    if (letter == '*')
    {
        return id;
    }
    return -1;
}

void addGear(int gears[10], int gearId, int *length)
{
    for (size_t i = 0; i < *length; i++)
    {
        if (gears[i] == gearId)
        {
            return;
        }
    }
    gears[*length] = gearId;
    *length += 1;
}

// I don't know how to name this function
void a(int gears[50], int gearsCount, int gearsPositions[300][3], int *gearsPositionsCount, char numberBuffer[10], int *output)
{
    for (size_t i = 0; i < gearsCount; i++)
    {
        bool found = false;
        if (gears[i] == -1)
        {
            continue;
        }
        for (size_t j = 0; j < 300; j++)
        {
            if (gearsPositions[j][1] == 0)
            {
                break;
            }
            if (gearsPositions[j][0] == gears[i])
            {
                if (gearsPositions[j][2] == true)
                {
                    printf("Gear %d already used %d\n", gears[i], atoi(numberBuffer));
                    return;
                }
                *output += gearsPositions[j][1] * atoi(numberBuffer);
                gearsPositions[j][2] = true;
                found = true;
                break;
            }
        }
        if (!found)
        {
            gearsPositions[*gearsPositionsCount][0] = gears[i];
            gearsPositions[*gearsPositionsCount][1] = atoi(numberBuffer);
            gearsPositions[*gearsPositionsCount][2] = false;
            *gearsPositionsCount += 1;
            *gearsPositionsCount %= 300;
        }
    }
}

int main()
{
    FILE *input_file = fopen("input.txt", "r");

    int gearsPositionsCount = 0;
    int gearsPositions[300][3] = {-1};

    Line lastLine = NULL;

    bool endOfFile = false;

    int output = 0;

    int numberBufferIndex = 0;
    char numberBuffer[10];
    Line nextLine = NULL;

    int lineNumber = 0;
    unsigned int lineLength = 0;
    while (!endOfFile)
    {
        Line currentLine;
        if (nextLine != NULL)
        {
            currentLine = nextLine;
            nextLine = NULL;
        }
        else
        {
            currentLine = readLine(input_file, &endOfFile);
            if (lineLength == 0)
            {
                lineLength = strlen(currentLine);
            }
        }

        int j = 0;
        bool symbolFound = false;

        int gearsCount = 0;
        int gears[50] = {0};

        while (currentLine[j] != '\0')
        {
            char letter = currentLine[j];
            if (letter >= 48 && letter <= 57)
            {
                numberBuffer[numberBufferIndex] = letter;
                numberBufferIndex++;
                if (nextLine == NULL)
                {
                    nextLine = readLine(input_file, &endOfFile);
                    if (endOfFile)
                    {
                        nextLine = NULL;
                    }
                }

                for (int x = -1; x <= 1; x++)
                {

                    int xx = x + j;
                    if (xx < 0 || xx >= strlen(currentLine))
                    {
                        continue;
                    }
                    char nextLetter = '.';
                    if (nextLine != NULL)
                    {
                        nextLetter = nextLine[xx];
                    }
                    char lastLetter = '.';
                    if (lastLine != NULL)
                    {
                        lastLetter = lastLine[xx];
                    }
                    if (PART_TWO)
                    {
                        int currentGearId = isGear(currentLine[xx], (lineLength * xx) + lineNumber);
                        int nextGearId = isGear(nextLetter, (lineLength * xx + 1) + lineNumber);
                        int lastGearId = isGear(lastLetter, (lineLength * xx - 1) + lineNumber);
                        if (currentGearId > 0)
                        {
                            addGear(gears, currentGearId, &gearsCount);
                        }
                        if (nextGearId > 0)
                        {
                            addGear(gears, nextGearId, &gearsCount);
                        }
                        if (lastGearId > 0)
                        {
                            addGear(gears, lastGearId, &gearsCount);
                        }

                        if (currentGearId > 0 || nextGearId > 0 || lastGearId > 0)
                        {
                            symbolFound = true;
                            break;
                        }
                    }
                    else
                    {
                        if (isSymbol(currentLine[xx]) || isSymbol(nextLetter) || isSymbol(lastLetter))
                        {
                            symbolFound = true;
                            break;
                        }
                    }
                }
            }
            else if (isNumber(letter) == false)
            {
                if (symbolFound)
                {
                    numberBuffer[numberBufferIndex] = '\0';
                    if (PART_TWO)
                    {
                        a(gears, gearsCount, gearsPositions, &gearsPositionsCount, numberBuffer, &output);
                        gearsCount = 0;
                    }
                    else
                    {
                        output += atoi(numberBuffer);
                    }
                }
                symbolFound = false;
                numberBufferIndex = 0;
            }
            j++;
        }
        if (symbolFound)
        {
            numberBuffer[numberBufferIndex] = '\0';
            printf("%d\n", atoi(numberBuffer));
            if (PART_TWO)
            {
                a(gears, gearsCount, gearsPositions, &gearsPositionsCount, numberBuffer, &output);
                gearsCount = 0;
            }
            else
            {
                output += atoi(numberBuffer);
            }
        }
        free(lastLine);
        lastLine = currentLine;
        lineNumber++;
    }
    printf("Output: %d\n", output);
    free(lastLine);
    fclose(input_file);
    return 0;
}