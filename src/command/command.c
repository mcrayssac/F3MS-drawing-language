// File: command.c
// Description: Command implementation
// Author: CRAYSSAC Maxime
// Date: 2024-10-31

#include "../external/external.h"
#include "command.h"

/* Command list */
Command command_list[1000];
int command_count = 0;

/* Add a command to the command list */
void add_command(Command cmd) {
    if (command_count >= 1000) {
        fprintf(stderr, "Too many commands\n");
        exit(1);
    }
    command_list[command_count++] = cmd;
}