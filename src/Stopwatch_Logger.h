#pragma once

#include <sys/syscall.h>

#include <chrono>
#include <iostream>
#include <memory>

#include <util/String.h>

// Usage samples:
//
//  #include "/home/vagrant/unix/src/Stopwatch_Logger.h"
//
//  // Directly instantiate and use Stopwatch_Logger.
//  {
//      Stopwatch_Logger swl("direct");
//
//      do_1();
//      swl.lap("do_1");
//
//      do_2();
//      sql.lap("do_2");
//  }
//
//  // Conditionally use Stopwatch_Logger.
//  {
//      std::unique_ptr<Stopwatch_Logger> swl;
//
//      if (condition)
//      {
//          swl = std::make_unique<stopwatch_logger>("conditional");
//      }
//
//      do_1();
//      if (swl) swl->lap("do_1");
//
//      do_2();
//      if (swl) swl->lap("do_2");
//  }

class Stopwatch_Logger
{
private:
    typedef std::chrono::steady_clock::time_point Time_Point;

public:
    Stopwatch_Logger(std::string const title) : m_message(title)
    {
        m_message
            .append("[")
            .append(std::to_string(m_tid))
            .append("]")
            ;
    }

    ~Stopwatch_Logger()
    {
        Time_Point const stop_time { now() };

        if (0 < duration(m_start_time, m_lap_time))
        {
            lap("stop", stop_time);
        }

        m_message
            .append(": Total=")
            .append(duration_as_string(m_start_time, stop_time))
            .append(" ms")
            ;

        std::cout << m_message << std::endl;
    }

    void lap(std::string const name)
    {
        lap(name, now());
    }

private:
    void lap(std::string const name, Time_Point const new_lap_time)
    {
        m_message
            .append(": ")
            .append(name)
            .append("=")
            .append(duration_as_string(m_lap_time, new_lap_time))
            .append(" ms")
            ;

        m_lap_time = { new_lap_time };
    };

    Time_Point now() const { return std::chrono::steady_clock::now(); }

    std::string duration_as_string(Time_Point const & t1, Time_Point const & t2) const
    {
        double const ms { static_cast<double>(duration(t1, t2)) / 1'000.0 };

        Util::string32 ms_string;
        ms_string.printf("%.3f", ms);

        return ms_string.c_str();
    }

    int64_t duration(Time_Point const & t1, Time_Point const & t2) const
    {
        return std::chrono::duration_cast<std::chrono::microseconds>(t2 - t1).count();
    }

    long const m_tid { syscall(SYS_gettid) };
    Time_Point const m_start_time { now() };
    Time_Point m_lap_time { m_start_time };
    std::string m_message;
};
