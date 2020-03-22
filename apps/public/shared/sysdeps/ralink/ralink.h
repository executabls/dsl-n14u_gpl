/*
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */
#ifndef RTXXXXH
#define RTXXXXH


#define WIF	"ra0"
#define WIF_5G	"ra0"
#define WIF_2G	"rai0"
#define URE	"apcli0"

#define ETHER_ADDR_LEN		6
#define MAX_NUMBER_OF_MAC	32

#define MODE_CCK		0
#define MODE_OFDM		1
#define MODE_HTMIX		2
#define MODE_HTGREENFIELD	3

#define BW_20			0
#define BW_40			1
#define BW_BOTH			2
#define BW_10			3

// MIMO Tx parameter, ShortGI, MCS, STBC, etc.  these are fields in TXWI. Don't change this definition!!!
typedef union  _MACHTTRANSMIT_SETTING {
        struct  {
        unsigned short	MCS:7;	// MCS
        unsigned short	BW:1;	//channel bandwidth 20MHz or 40 MHz
        unsigned short	ShortGI:1;
        unsigned short	STBC:2;	//SPACE 
	unsigned short  eTxBF:1;
	unsigned short  rsv:1;
	unsigned short  iTxBF:1;
	unsigned short  MODE:2;	// Use definition MODE_xxx.
        } field;
        unsigned short	word;
 } MACHTTRANSMIT_SETTING, *PMACHTTRANSMIT_SETTING;

// MIMO Tx parameter, ShortGI, MCS, STBC, etc.  these are fields in TXWI. Don't change this definition!!!
typedef union  _MACHTTRANSMIT_SETTING_2G {
        struct  {
        unsigned short	MCS:7;	// MCS
        unsigned short	BW:1;	//channel bandwidth 20MHz or 40 MHz
        unsigned short	ShortGI:1;
        unsigned short	STBC:2;	//SPACE 
        unsigned short	rsv:3;
        unsigned short	MODE:2;	// Use definition MODE_xxx.  
        } field;
        unsigned short	word;
 } MACHTTRANSMIT_SETTING_2G, *PMACHTTRANSMIT_SETTING_2G;

typedef struct _RT_802_11_MAC_ENTRY {
    unsigned char	ApIdx;
    unsigned char	Addr[ETHER_ADDR_LEN];
    unsigned char	Aid;
    unsigned char	Psm;     // 0:PWR_ACTIVE, 1:PWR_SAVE
    unsigned char	MimoPs;  // 0:MMPS_STATIC, 1:MMPS_DYNAMIC, 3:MMPS_Enabled
    char		AvgRssi0;
    char		AvgRssi1;
    char		AvgRssi2;
    unsigned int	ConnectedTime;
    MACHTTRANSMIT_SETTING       TxRate;
    unsigned int	LastRxRate;
    int			StreamSnr[3];
    int			SoundingRespSnr[3];
} RT_802_11_MAC_ENTRY, *PRT_802_11_MAC_ENTRY;

typedef struct _RT_802_11_MAC_ENTRY_2G {
    unsigned char	ApIdx;
    unsigned char	Addr[ETHER_ADDR_LEN];
    unsigned char	Aid;
    unsigned char	Psm;	// 0:PWR_ACTIVE, 1:PWR_SAVE
    unsigned char	MimoPs;	// 0:MMPS_STATIC, 1:MMPS_DYNAMIC, 3:MMPS_Enabled
    char		AvgRssi0;
    char		AvgRssi1;
    char		AvgRssi2;
    unsigned int	ConnectedTime;
    MACHTTRANSMIT_SETTING_2G	TxRate;
} RT_802_11_MAC_ENTRY_2G, *PRT_802_11_MAC_ENTRY_2G;

typedef struct _RT_802_11_MAC_TABLE {
    unsigned long	Num;
    RT_802_11_MAC_ENTRY Entry[MAX_NUMBER_OF_MAC];
} RT_802_11_MAC_TABLE, *PRT_802_11_MAC_TABLE;

typedef struct _RT_802_11_MAC_TABLE_2G {
    unsigned long	Num;
    RT_802_11_MAC_ENTRY_2G Entry[MAX_NUMBER_OF_MAC];
} RT_802_11_MAC_TABLE_2G, *PRT_802_11_MAC_TABLE_2G;

typedef struct _SITE_SURVEY 
{ 
	char channel[4];
//	unsigned char channel;
//	unsigned char centralchannel;
//	unsigned char unused;
	unsigned char ssid[33]; 
	char bssid[18];
	char encryption[9];
	char authmode[16];
	char signal[9];
	char wmode[8];
//	char bsstype[3];
//	char centralchannel[3];
} SITE_SURVEY;

typedef struct _SITE_SURVEY_ARRAY
{ 
	SITE_SURVEY SiteSurvey[64];
} SSA;

#define SITE_SURVEY_APS_MAX	(16*1024)

//#if WIRELESS_EXT <= 11 
//#ifndef SIOCDEVPRIVATE 
//#define SIOCDEVPRIVATE 0x8BE0 
//#endif 
//#define SIOCIWFIRSTPRIV SIOCDEVPRIVATE 
//#endif 
//
//SET/GET CONVENTION :
// * ------------------
// * Simplistic summary :
// * o even numbered ioctls are SET, restricted to root, and should not
// * return arguments (get_args = 0).
// * o odd numbered ioctls are GET, authorised to anybody, and should
// * not expect any arguments (set_args = 0).
//
#define RT_PRIV_IOCTL			(SIOCIWFIRSTPRIV + 0x01)
#define RTPRIV_IOCTL_SET		(SIOCIWFIRSTPRIV + 0x02)
#define RTPRIV_IOCTL_GSITESURVEY	(SIOCIWFIRSTPRIV + 0x0D)
#define RTPRIV_IOCTL_WSC_PROFILE	(SIOCIWFIRSTPRIV + 0x12)
#define	RTPRIV_IOCTL_GSTAINFO		(SIOCIWFIRSTPRIV + 0x1A)
#define	RTPRIV_IOCTL_GSTAT		(SIOCIWFIRSTPRIV + 0x1B)
#define RTPRIV_IOCTL_GRSSI		(SIOCIWFIRSTPRIV + 0x1C)
#define RTPRIV_IOCTL_GTXBFCALP		(SIOCIWFIRSTPRIV + 0x1D)
#define OID_802_11_DISASSOCIATE		0x0114
#define OID_802_11_BSSID_LIST_SCAN	0x0508
#define OID_802_11_SSID			0x0509
#define OID_802_11_BSSID		0x050A
#define RT_OID_802_11_RADIO		0x050B
#define OID_802_11_BSSID_LIST		0x0609
#define OID_802_3_CURRENT_ADDRESS	0x060A
#define OID_GEN_MEDIA_CONNECT_STATUS	0x060B
#define RT_OID_GET_PHY_MODE		0x0761
#define OID_GET_SET_TOGGLE		0x8000
#define RT_OID_SYNC_RT61		0x0D010750
#define RT_OID_WSC_QUERY_STATUS		((RT_OID_SYNC_RT61 + 0x01) & 0xffff)
#define RT_OID_WSC_PIN_CODE		((RT_OID_SYNC_RT61 + 0x02) & 0xffff)

#if 0
typedef enum _RT_802_11_PHY_MODE {
	PHY_11BG_MIXED = 0,
	PHY_11B,
	PHY_11A,
	PHY_11ABG_MIXED,
	PHY_11G,
	PHY_11ABGN_MIXED,	// both band		5
	PHY_11N,		//			6
	PHY_11GN_MIXED,		// 2.4G band		7
	PHY_11AN_MIXED,		// 5G  band		8
	PHY_11BGN_MIXED,	// if check 802.11b.	9
	PHY_11AGN_MIXED,	// if check 802.11b.	10
} RT_802_11_PHY_MODE;
#endif

#define OFFSET_BOOT_VER		0x4018A
#define OFFSET_COUNTRY_CODE	0x40188
#define OFFSET_MAC_ADDR		0x40004
#define OFFSET_MAC_ADDR_2G	0x48004
#define OFFSET_MAC_GMAC2	0x40022
#define OFFSET_MAC_GMAC0	0x40028
#define OFFSET_PIN_CODE		0x40180
#define OFFSET_TXBF_PARA	0x401A0
#define OFFSET_SERIAL_NUMBER	0x4fff0

#define SR3

#define RA_LED_ON		0	// low active (all 5xx series)
#define RA_LED_OFF		1

#define RA_LED_POWER	0
#define RA_LED_USB		24
#ifndef SR3
#define RA_BTN_RESET	25
#else
#define RA_BTN_RESET	13
#endif
#define RA_BTN_WPS		26
#define RA_LED_WAN		27
#ifndef SR3
#define RA_LED_LAN		31
#else
#define RA_LED_LAN		19
#endif
/*
#define RTN13U_SW1	9
#define RTN13U_SW2	13
#define RTN13U_SW3	11
*/

#define GPIO_DIR_OUT	1
#define GPIO_DIR_IN	0

#define GPIO0		0x0001
#define GPIO1		0x0002
#define GPIO2		0x0004
#define GPIO3		0x0008
#define GPIO4		0x0010
#define GPIO5		0x0020
#define GPIO6		0x0040
#define GPIO7		0x0080
#define GPIO15		0x8000

#define TASK_HTTPD       0
#define TASK_UDHCPD      1
#define TASK_LLD2D       2
#define TASK_WANDUCK     3
#define TASK_UDHCPC      4
#define TASK_NETWORKMAP  5
#define TASK_DPROXY      6
#define TASK_NTP         7
#define TASK_U2EC        8
#define TASK_OTS         9
#define TASK_LPD         10
#define TASK_UPNPD       11
#define TASK_WATCHDOG    12
#define TASK_INFOSVR     13
#define TASK_SYSLOGD     14
#define TASK_KLOGD       15
#define TASK_PPPD        16
#define TASK_PPPOE_RELAY 17
#define TASK_IGMP	 18

unsigned long task_mask;

int switch_init(void);

void switch_fini(void);

int ra3052_reg_read(int offset, int *value);

int ra3052_reg_write(int offset, int value);

int config_3052(int type);

int restore_3052();

void ra_gpio_write_spec(bit_idx, flag);

int check_all_tasks();

int ra_gpio_set_dir(int dir);

int ra_gpio_write_int(int value);

int ra_gpio_read_int(int *value);

int ra_gpio_write_bit(int idx, int value);

#endif
