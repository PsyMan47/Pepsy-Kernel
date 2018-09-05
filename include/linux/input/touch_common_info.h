#ifndef _TOUCH_COMMON_INFO_H_
#define _TOUCH_COMMON_INFO_H_

/*
 *if add new vendor info, need insert before default
 */

#define HWCOMPONENT_NAME_TOUCH                 "touch"
#define HWMON_CONPONENT_NAME 					"touch"
#define HWCOMPONENT_KEY_IC						"TOUCH IC"
#define HWCOMPONENT_KEY_MODULE					"TP MAKER"
#define HWMON_KEY_DBCLICK_SWITCH 				"doubleclick_switch"
#define HWMON_KEY_DBCLICK_COUNT 				"doubleclick_count"
static inline u8 *update_hw_component_touch_module_info(unsigned int value)
{
	switch (value) {
	case 0x31:
		  return "Biel";
	case 0x32:
		  return "Lens";
	case 0x34:
		  return "Ofilm";
	case 0x35:
		  return "Biel-D1";
	case 0x36:
		  return "Tpk";
	case 0x38:
		  return "Sharp";
	case 0x42:
		  return "Lg";
	default:
		  return "Unknown";
	}

}
#endif
