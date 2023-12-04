#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#define PART_TWO true

#define IsNumber(letter) (letter >= 48 && letter <= 57)

bool checkNeighbours(int X, int Y, char **lines, int linesLength, char *chr, int *gearId)
{
    for (int x = -1; x <= 1; x++)
    {
        for (int y = -1; y <= 1; y++)
        {
            if (x == 0 && y == 0)
            {
                continue;
            }
            int xx = X + x;
            int yy = Y + y;
            if (xx < 0 || yy < 0)
            {
                continue;
            }
            if (xx < 0 || yy >= linesLength || xx > strlen(lines[Y]))
            {
                continue;
            }
            char letter = lines[yy][xx];
            if (!IsNumber(letter) && letter != '.' && letter != 0)
            {
                *chr = letter;
                *gearId = strlen(lines[yy]) * yy + xx;
                return true;
            }
        }
    }
    return false;
}

typedef struct NumberBuffer
{
    size_t size;
    char buffer[10];
} NumberBuffer;

void addToBuffer(NumberBuffer *buffer, char chr)
{
    buffer->buffer[buffer->size] = chr;
    buffer->size++;
}
char **readLines(FILE *file, int *lines)
{
    int lineLength = 0;
    *lines = 0;
    int maxLines = 100;
    char **output = malloc(maxLines * sizeof(char *));

    char *line = NULL;
    char letter;
    for (;;)
    {
        letter = fgetc(file);
        if (letter == EOF)
        {
            line[lineLength] = '\0';
            if (*lines >= maxLines)
            {
                maxLines += 50;
                output = realloc(output, maxLines * sizeof(char *));
            }
            output[*lines] = line;
            line = NULL;
            *lines += 1;
            break;
        }
        if (letter == '\n')
        {
            line[lineLength] = '\0';
            if (*lines >= maxLines)
            {
                maxLines += 50;
                output = realloc(output, maxLines * sizeof(char *));
                if (output == NULL)
                {
                    printf("Error allocating memory %d\n", maxLines);
                    exit(1);
                }
            }
            output[*lines] = line;
            line = NULL;
            *lines += 1;
            continue;
        }
        if (line == NULL)
        {
            line = malloc(1);
            lineLength = 0;
        }
        line = realloc(line, lineLength + 1 * sizeof(char));
        if (line == NULL)
        {
            printf("Error allocating memory\n");
            exit(1);
        }
        line[lineLength] = letter;
        lineLength++;
    }
    if (*lines < maxLines)
    {
        output = realloc(output, *lines * sizeof(char *));
    }

    return output;
}

typedef struct Gear
{
    int id;
    int value;
} Gear;

typedef struct GearList
{
    Gear *gears;
    int length;
    int maxLength;
} GearList;

void addGear(GearList *List, Gear gear)
{
    if (List->length >= List->maxLength)
    {
        List->maxLength += 100;
        List->gears = realloc(List->gears, List->maxLength * sizeof(Gear));
    }
    List->gears[List->length] = gear;
    List->length += 1;
}
int indexOfGear(GearList list, int id)
{
    for (size_t i = 0; i < list.length; i++)
    {
        if (list.gears[i].id == id)
        {
            return i;
        }
    }
    return -1;
}

int main()
{
    FILE *input_file = fopen("input.txt", "r");

    int output = 0;
    int linesLength;
    char **lines = readLines(input_file, &linesLength);

    NumberBuffer buffer = {0, {0}};
    char specialChar = 0;
    int gearId = 0;

    GearList gears = {malloc(100 * sizeof(Gear)), 0, 100};

    for (size_t i = 0; i < linesLength; i++)
    {
        for (size_t j = 0; j < strlen(lines[i]); j++)
        {
            char letter = lines[i][j];
            if (IsNumber(letter))
            {
                addToBuffer(&buffer, letter);
                checkNeighbours(j, i, lines, linesLength, &specialChar, &gearId);
            }
            else
            {
                if (specialChar != 0)
                {
                    buffer.buffer[buffer.size] = '\0';
                    int number = atoi(buffer.buffer);
                    if (PART_TWO)
                    {
                        if (specialChar == '*')
                        {
                            int index = indexOfGear(gears, gearId);

                            // printf("Gear %d * %d\n", gearId, number);
                            printf("%d\n", number);
                            if (index == -1)
                            {
                                Gear gear = {gearId, number};
                                addGear(&gears, gear);
                            }
                            else
                            {
                                output += gears.gears[index].value * number;
                            }
                        }
                    }
                    else
                    {
                        output += number;
                        printf("%d\n", atoi(buffer.buffer));
                    }
                }
                buffer.size = 0;
                specialChar = 0;
            }
        }
        if (specialChar != 0)
        {
            if (PART_TWO)
            {
                if (specialChar == '*')
                {
                    int index = indexOfGear(gears, gearId);
                    if (index == -1)
                    {
                        Gear gear = {gearId, atoi(buffer.buffer)};
                        addGear(&gears, gear);
                    }
                    else
                    {
                        output += gears.gears[index].value * atoi(buffer.buffer);
                    }
                }
            }
            else
            {
                buffer.buffer[buffer.size] = '\0';
                output += atoi(buffer.buffer);
                printf("%d\n", atoi(buffer.buffer));
            }
            buffer.size = 0;
            specialChar = 0;
        }
    }
    printf("Output: %d\n", output);
    free(lines);
    free(gears.gears);

    return 0;
}