#!/bin/bash


DEEP_HOME=/opt/deepspeech
DSS=/usr/local/bin/deepspeech-server
CONFIG="${DEEP_HOME}/config.json"
DSC="${DSS} --config ${CONFIG}"
RUN_CMD="screen -mdS Deepspeech-Server ${DSC}" 

check-server() {
if pgrep -f deepspeech-server > /dev/null ; then
  return 1
fi
return 0
}

start-server() {
if ! check-server ; then
  echo "Detected another instance of deepspeech-server running, exiting!"
  exit 98
fi
echo "Starting server..." 

$RUN_CMD
if [[ $? -eq 0 ]] ; then
  echo "Started!"
else
  echo "Problem starting server!"
  exit 99
fi

}

stop-server() {
if screen -X -S Deepspeech-Server quit ; then
  echo "deepspeech-server stopped!"
else
  if check-server; then
    echo "Unable to stop server, manual intervention may be required."
    exit 92
  else
    echo "No instance of deepspeech-server appears to be running."
    exit 93
  fi
fi

}

case $1 in
  start)
    start-server
  ;;
  stop)
    stop-server
  ;;
  restart|force-reload)
        $0 stop
        sleep 1
        $0 start
  ;;
  status)
    if check-server ; then
      echo "Did not detect an instance of deepspeech-server running."
      exit 89
    else
      echo "deepspeech-server appears to be running."
    fi
  ;;
  *)
    echo "Usage: $0 {start|stop|restart|force-reload|status}" >&2
    exit 1
  ;;
esac

exit 0
