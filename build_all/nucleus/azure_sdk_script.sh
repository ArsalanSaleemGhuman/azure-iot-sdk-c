#!/bin/sh


SDK_PATH=../../

cd $SDK_PATH

#set clean to 1 if all local changes are to be cleaned.
clean=0

if test $clean -eq 1
then
    git clean -fd
    git reset --hard
    cd c-utility
    git clean -fd
    git reset --hard
    cd ..
    cd uamqp
    git reset --hard
    git clean -fd
    cd ..
    cd umqtt
    git reset --hard
    git clean -fd
    cd ..
fi;


cmake -DCMAKE_TOOLCHAIN_FILE=./build_all/nucleus/toolset_csgnu_arm.cmake -Duse_openssl=OFF -Duse_wolfssl=ON  -DTHREAD_C_FILE=./adapters/threadapi_nucleus.c -Duse_condition=NO -DLOCK_C_FILE=./adapters/lock_nucleus.c -DPLATFORM_C_FILE=./adapters/platform_nucleus.c -DTICKCOUTER_C_FILE=./adapters/tickcounter_nucleus.c   -Duse_default_uuid=ON -Duse_builtin_httpapi=ON  -Dwip_use_c2d_amqp_methods=ON -Dnucleus=ON -Dnucleus_sample_http=ON -Dnucleus_sample_amqp=ON -Dnucleus_sample_mqtt=ON CMakeLists.txt

make

arm-none-eabi-objcopy -O binary iothub_client/samples/iothub_client_sample_http/iothub_client_sample_http iothub_client/samples/iothub_client_sample_http/iothub_client_sample_http.bin

arm-none-eabi-objcopy -O binary iothub_client/samples/iothub_client_sample_amqp/iothub_client_sample_amqp iothub_client/samples/iothub_client_sample_amqp/iothub_client_sample_amqp.bin

arm-none-eabi-objcopy -O binary iothub_client/samples/iothub_client_sample_mqtt/iothub_client_sample_mqtt iothub_client/samples/iothub_client_sample_mqtt/iothub_client_sample_mqtt.bin

