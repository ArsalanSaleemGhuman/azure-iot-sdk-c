// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

#include <stdio.h>
#include <stdlib.h>

/* This sample uses the _LL APIs of iothub_client for example purposes.
That does not mean that HTTP only works with the _LL APIs.
Simply changing the using the convenience layer (functions not having _LL)
and removing calls to _DoWork will yield the same results. */
/* Required include files for C STDIO and Nucleus PLUS kernel services */
#include <stdio.h>
#include "nucleus.h"
#include "kernel/nu_kernel.h"
#include "networking/nu_networking.h"

/* Define the main task's stack size */
#define HELLO_WORLD_TASK_STACK_SIZE      (NU_MIN_STACK_SIZE * 16)

/* Define the main task's priority */
#define HELLO_WORLD_TASK_PRIORITY   26

/* Define the main task's time slice */
#define HELLO_WORLD_TASK_TIMESLICE  20

/* Statically allocate the main task's control block */
static NU_TASK Task_Control_Block;

/* Prototype for the main task's entry function */
static VOID Main_Task_Entry(UNSIGNED argc, VOID *argv);

/***********************************************************************
 * *
 * *   FUNCTION
 * *
 * *       Application_Initialize
 * *
 * *   DESCRIPTION
 * *
 * *       Demo application entry point - initializes Nucleus Plus
 * *       demonstration application by creating and initializing necessary
 * *       tasks, memory pools, and communication components.
 * *
 * ***********************************************************************/
VOID Application_Initialize(NU_MEMORY_POOL* mem_pool,
                            NU_MEMORY_POOL* uncached_mem_pool)
{
    VOID *pointer;
    STATUS status;

    /* Reference unused parameters to avoid toolset warnings */
    NU_UNUSED_PARAM(uncached_mem_pool);

    /* Allocate memory for the main task */
    status = NU_Allocate_Memory(mem_pool, &pointer,
                                HELLO_WORLD_TASK_STACK_SIZE, NU_NO_SUSPEND);

    /* Check to see if previous operation was successful */
    if (status == NU_SUCCESS)
    {
        /* Create task 0.  */
        status = NU_Create_Task(&Task_Control_Block, "MAIN", Main_Task_Entry,
                                0, NU_NULL, pointer, HELLO_WORLD_TASK_STACK_SIZE,
                                HELLO_WORLD_TASK_PRIORITY, HELLO_WORLD_TASK_TIMESLICE,
                                NU_PREEMPT, NU_START);
    }

    /* Check to see if previous operations were successful */
    if (status != NU_SUCCESS)
    {
        /* Loop forever */
        while(1);
    }
}

/***********************************************************************
 * *
 * *   FUNCTION
 * *
 * *       Main_Task_Entry
 * *
 * *   DESCRIPTION
 * *
 * *       Entry function for the main task. This task prints a hello world
 * *       message.
 * *
 * ***********************************************************************/
static VOID Main_Task_Entry(UNSIGNED argc, VOID *argv)
{
    STATUS 				status = NU_SUCCESS;
    SNTPC_TIME			time;
    SNTPC_SERVER		server;

	/* Reference all parameters to ensure no toolset warnings */
    NU_UNUSED_PARAM(argc);
    NU_UNUSED_PARAM(argv);

    printf("\r\nHello Nucleus world!\r\n");
    printf("\r\nHello Nucleus world!\r\n");
    printf("\r\nHello Nucleus world!\r\n");

    /* Wait until the NET stack is initialized. */
    status = NETBOOT_Wait_For_Network_Up(NU_SUSPEND);

    server.sntpc_poll_interval = 1800;
    server.sntpc_server_addr.port = 123;
    server.sntpc_server_hostname =	"0.pool.ntp.org";
    server.sntpc_server_addr.family = NU_FAMILY_IP;

    status = SNTPC_Add_Server(&server);

    /* Get time from sntp server. */
	do
	{
		status = SNTPC_Get_Time(&time);

		NU_Sleep(100);

	} while (status != NU_SUCCESS);

	/* Set clock according to current time. */
    NU_Set_Clock64(NU_Time_To_Ticks(time.sntpc_seconds));

    if (status == NU_SUCCESS)
    {
 printf("\r\nHello Nucleus world!\r\n");
    	main();
    }
}

