set print pretty on
set print object on
set print vtbl on
set print demangle on

# Keep running process until a signal is received.
define run_until_failure
    while 1
      run
      if $_siginfo
        printf "Received signal %d, stopping\n", $_siginfo.si_signo
        loop_break
      end
    end
end

# sets the focus to command window
define fc
    focus cmd
end

# sets the focus to src window
define fs
    focus src
end

define lb
    source ./breakpoints.txt
end

define sb
    save breakpoints ./breakpoints.txt
end

define snl
    tbreak +1
    jump +1
end

printf "\n"
printf "-------------------------------------------------------------------------\n"
printf "               fc - focus on command window (focus cmd)\n"
printf "               fs - focus on src window (focus src)\n"
printf "           layout - split window\n"
printf "               lb - load breakpoints (source ./breakpoints.txt)\n"
printf "run_until_failure - keep running process until a signal is received\n"
printf "               sb - save breakpoints (save breakpoints ./breakpoints.txt)\n"
printf "              snl - skip next line of execution\n"
printf "-------------------------------------------------------------------------\n"
printf "\n"

# this will make debugging the XL process more pleasant
# thrown from libfcgi when http requests are interrupted (like when a client resets)
handle SIGPIPE nostop noprint pass

# make GDB pass the signal straight to the inferior (being debugged) process
handle SIGINT nostop print pass

# macros for printing Qt nicely
# source ~/unix/gdb/kde-qt.gdb

# macros for printing stl nicely
source ~/unix/gdb/stl-views.gdb
