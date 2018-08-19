#include <sys/ioctl.h>

#include <string.h>
#include <unistd.h>

#include <chrono>
#include <iostream>
#include <string>
#include <thread>

#include "Signals.h"

static Signals s_signals;

static std::string box(size_t const rows, size_t const columns)
{
    std::string line;
    for (size_t i=0; i<columns-2; ++i)
    {
        line.append(u8"\u2550");
    }

    std::string box;

    box.append(u8"\u2554").append(line).append(u8"\u2557");
    {
        std::string middle;
        middle.append(u8"\u2551").append(std::string(columns-2, ' ')).append(u8"\u2551");
        for (size_t i=0; i<rows-2; ++i)
        {
            box.append(middle);
        }
    }
    box.append(u8"\u255A").append(line); //.append(u8"\u255D");

    return box;
}

static void print_window_size()
{
    if (s_signals.window_size_was_changed())
    {
        winsize w {};

        if (ioctl(STDOUT_FILENO, TIOCGWINSZ, &w) == -1)
        {
            char error_buffer[64] {};
            std::cout << "Call to ioctl failed: " << strerror_r(errno, error_buffer, sizeof(error_buffer)) << std::endl;
        }

        //std::cout << "\x1B[2K\x1B[0G";
        //std::cout << "Lines=" << w.ws_row << ", Columns=" << w.ws_col << std::flush;

        //std::string const s { u8"\u2560" };
        //std::cout << " " << s << std::flush;

        std::cout << "\x1B[36;40m" << "\x1B[2J\x1B[0;0H" << box(w.ws_row, w.ws_col) << "\x1B[97;40m" << std::flush;
        //std::cout << "Lines=" << w.ws_row << ", Columns=" << w.ws_col << std::flush;
    }
}

int main()
{
    while (true)
    {
        print_window_size();
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }

    std::cout << std::endl;

    return 0;
}
