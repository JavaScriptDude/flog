#!/bin/bash
# Home: https://github.com/JavaScriptDude/flog
# Author: Timothy C. Quinn
# Date: 2025-07-15
# Usage: see flog -h
# Installation: 
#   % sudo cp ./flog.sh /usr/bin/local/flog
#   % sudo chmod +x /usr/bin/local/flog

flog_main() { 

  local def_lines=250
  local wait_secs=3

  # unnamed args
  local file=
  # named args
  local help=false
  local quiet=false
  local lines=$def_lines
  # other
  local OK=true
  

  while (( $# >= 1 )); do 
      if [[ $1 == -* ]]; then
          case $1 in
          --quiet|-q)     quiet=true;    shift;;
          --lines|-n)     lines="$2"; shift 2;;
          --help|-h|-\?)  help=true;    shift;;
          *) msg="Invalid option: $1"; OK=false; help=true; break;;
          esac;
      else
          uargs+=("$1")
          shift
      fi
  done

  if [ ${#uargs[@]} -gt 1 ]; then
    echo "Error: Only one unnamed parameter is allowed."
    help=true
    OK=false
  else
    if ! $help; then
      # if no unnamed args AND not help, then we need a file
      if [ ${#uargs[@]} -eq 0 ]; then
        echo "Error: No file specified."
        help=true
        OK=false  
      else
        file=(${uargs[0]})

        # if $file exists but its not a file, then error
        if [ -e "$file" ] && [ ! -f "$file" ]; then
          echo "Error: '$file' exists but is not a regular file."
          help=true
          OK=false
        fi

        # ensure file exists
        if [ ! -f "$file" ]; then
          # wait for file to exist and sleep for 4 second intervals
          while [ ! -f "$file" ]; do
            echo "Waiting ${wait_secs}s for file '$file' to exist ..."
            sleep $wait_secs
          done
        fi
      fi
    fi
  fi

  
  if $help; then
    echo "Usage: flog [options] <file_name>"
    echo "Simple wrapper for tail command with defaults --follow=name --retry --lines $def_lines --verbose)"
    echo "Options:"
    echo "  -q, --quiet     dont output headers giving file names"
    echo "  -n, --lines <n> output the last <n> lines (default: $def_lines)"
    echo "  -h, --help      show this help message"
    echo "  <any other tail(h) option>"
    OK=false
  fi


  if $OK; then
    # Build up the tail command
    cmd="tail -F --lines $lines"
    if [ "$quiet" != true ]; then
      cmd="$cmd --verbose"
    fi

    cmd="$cmd \"$file\""

    # echo "cmd: $cmd"

    bash -c "$cmd "
  fi

}

flog_main "$@"
