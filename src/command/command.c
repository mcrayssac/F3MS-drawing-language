// File: command.c
// Description: Command implementation
// Author: CRAYSSAC Maxime
// Date: 2024-10-31

#include "../external/external.h"
#include "command.h"

/* Command list */
LinkedList command_list = NULL;

/* Add a command to the command list */
void add_command(Command cmd) {
    Command *cmd_ptr = malloc(sizeof(Command));
    if (!cmd_ptr) {
        fprintf(stderr, "Memory allocation failed in add_command.\n");
        exit(EXIT_FAILURE);
    }
    *cmd_ptr = cmd;
    command_list = addInBack(command_list, cmd_ptr);
}