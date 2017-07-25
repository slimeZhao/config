#!/bin/bash

function is_running() {
    EMACSD="`ps -ef | grep 'emacs' | grep 'daemon' | awk '{print $9}' | sed 's/-//g'`";
    if [ -z ${EMACSD} ] ; then
        return 0;
    fi

    if [ ${EMACSD} = 'daemon'  ] ; then
        #the emacs daemon is running
        return 1;
    else
        return 0;
    fi
}

#check the number of arguments
if [ $# -ne 1 ] ; then
    echo 'The argument of method must be specified';
    echo 'arguments: start | status | restart | stop';
    exit 0;
fi

#try to start emacs daemon when the argument will be 'start'
if [ $1 = "start" ] ; then
    is_running;
    if [ $? -eq  1 ] ; then
        echo 'The emacs daemon is running'
    else
        echo 'It is starting emacs daemon'
        `emacs -daemon`
    fi
fi

#try to stop emacs daemon when the argument will be 'stop'
if [ $1 = 'stop' ] ; then
    is_running;
    if [ $? -eq 0 ] ; then
        echo 'The emacs dameon is not  running'
    else
        PID=`ps -ef | grep 'emacs' | grep 'daemon' | awk '{print $2}' | sed 's/-//g'`;
        `kill -9 ${PID}`;
        if [ $? -eq 0 ] ; then
            echo 'The emacs daemon was stopped'
        else
            echo 'fail at stop'
        fi
    fi
fi

#try to restart emacs daemon
if [ $1 = 'restart' ] ; then
    PID=`ps -ef | grep 'emacs' | grep 'daemon' | awk '{print $2}' | sed 's/-//g'`;
    if [ -n ${PID} ] ; then
        `kill -9 ${PID}`
        `emacs -daemon`
        if [ $? -eq 0 ] ; then
            echo 'Restart successfully'
        else
            echo 'Restart fail'
        fi
    else
        `emacs -daemon`
        if [ $? -eq 0] ; then
            echo 'Restart successfully'
        else
            echo 'Restart fail'
        fi
    fi
fi
