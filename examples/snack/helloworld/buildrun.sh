#!/bin/bash

#  Call buildrun.sh as follows

#  ./buildrun 
#  ./buildrun cpp
#  ./buildrun f
#

#  Set HSA Environment variables
[ -z $HSA_RUNTIME_PATH ] && HSA_RUNTIME_PATH=/opt/hsa
[ -z HSA_LIBHSAIL_PATH ] && HSA_LIBHSAIL_PATH=/opt/hsa/lib
[ -z HSA_LLVM_PATH ] && HSA_LLVM_PATH=/opt/amd/bin
export LD_LIBRARY_PATH=$HSA_RUNTIME_PATH/lib

#  First compile the acclerated functions to create hw.o
echo 
if [ "$1" == "f" ] ; then 
   echo snack.sh -q -fort -c hw.cl 
   snack.sh -q -fort -c hw.cl 
else
   echo snack.sh -q -c hw.cl 
   snack.sh -q -c hw.cl 
fi

#  Compile the main program and link to hw.o
#  Main program can be c, cpp, or fotran
echo 
if [ "$1" == "cpp" ] ; then 
   echo "g++ -o HelloWorld hw.o HelloWorld.cpp -L$HSA_RUNTIME_PATH/lib -lhsa-runtime64 -lelf "
   g++ -o HelloWorld hw.o HelloWorld.cpp -L$HSA_RUNTIME_PATH/lib -lhsa-runtime64 -lelf 
elif [ "$1" == "f" ] ; then 
   echo "f95 -o HelloWorld hw.o HelloWorld.f -L$HSA_RUNTIME_PATH/lib -lhsa-runtime64 -lelf "
   f95 -o HelloWorld hw.o HelloWorld.f -L$HSA_RUNTIME_PATH/lib -lhsa-runtime64 -lelf 
else
   echo "gcc -o HelloWorld hw.o HelloWorld.c -L$HSA_RUNTIME_PATH/lib -lhsa-runtime64 -lelf"
   gcc -o HelloWorld hw.o HelloWorld.c -L$HSA_RUNTIME_PATH/lib -lhsa-runtime64 -lelf
fi

echo 
echo ./HelloWorld
./HelloWorld
