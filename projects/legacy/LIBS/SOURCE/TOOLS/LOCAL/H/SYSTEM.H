// �keywords: system.h 1.0 mon 03-22-93 09:33:36�
// �lgb�
// 1.0     JACKN     mon 03-22-93 09:33:36
//         Original program.
// �lge�
// �nokeywords�

#ifndef _SYSTEM_H
#define _SYSTEM_H

// *************************
// * System Level Routines *
// *************************

// The SYSTEM module provides assembly routines which give the caller access
// to low-level functions.

struct EquipRecord {
	short	parallel;			// number of parallel ports
	short	serial;				// number of serial ports
	short	drives;				// number of block devices
	};

extern EquipRecord	equip;

void	EquipInit(void);			// initialize equip record
short	ShortHi(long val);
short	ShortLo(long val);
long	ShortShort(short hi, short lo);
Word	SysDate(void);				// current date
Word	SysTime(void);				// current time

#endif
