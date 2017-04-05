Overview:


1)Edit the 'NUCLEUS_SYS_PROJ' variable within the 'toolset_csgnu_arm.cmake' to your system project path.
Note: Incase you do not have ReadyStart installed required for the system project that contact www.mentor.com
 
2)Simply run the script 'azure_sdk_script.sh', it will run the cmake utility and the compile the code.
Note: Run the script 'azure_sdk_script.sh' from the same folder it is placed in. 

3)The http, amqp and mqtt demos will be compiled.

Note:
*You will have to update the device string in the samples and run the 'make' command. The script generates the samples with default value which is incorrect.

*If the .bin file is not generated then use the command 'arm-none-eabi-objcopy -O binary <file_name> <file_name.bin>' (incase of http demo the file name will be 'iothub_client_sample_http') to generate it.
