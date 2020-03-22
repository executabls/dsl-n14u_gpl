/*
 * Wireless interface translation utility functions
 *
 * Copyright (C) 2008, Broadcom Corporation
 * All Rights Reserved.
 * 
 * THIS SOFTWARE IS OFFERED "AS IS", AND BROADCOM GRANTS NO WARRANTIES OF ANY
 * KIND, EXPRESS OR IMPLIED, BY STATUTE, COMMUNICATION OR OTHERWISE. BROADCOM
 * SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A SPECIFIC PURPOSE OR NONINFRINGEMENT CONCERNING THIS SOFTWARE.
 *
 * $Id: wlif_utils.c,v 1.4 2008/10/02 04:09:46 Exp $
 */

#include <typedefs.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include <bcmparams.h>
#include <bcmnvram.h>
#include <bcmutils.h>
#include <shutils.h>
#include <wlutils.h>
#include <wlif_utils.h>

#include "shared.h"

#define MAX_NVPARSE 255

/* wireless interface name descriptors */
typedef struct _wlif_name_desc {
	char		*name;		/* wlif name */
	bool		wds;		/* wds interface */
	bool		subunit;		/* subunit existance */
} wlif_name_desc_t;

wlif_name_desc_t wlif_name_array[] = {
/*	  name	wds		subunit */
/* PARIMARY */
#if defined(linux)
	{ "eth",	0,		0}, /* primary */
#else
	{ "wl",	0,		0}, /* primary */
#endif

/* MBSS */
	{ "wl",	0,		1}, /* mbss */

/* WDS */
	{ "wds",	1,		1} /* wds */
};

/*
 * Translate virtual interface mac to spoof mac
 * Rule:
 *		00:aa:bb:cc:dd:ee                                              00:00:00:x:y:z
 *		wl0 ------------ [wlx/wlx.y/wdsx.y]0.1 ------ x=1/2/3, y=0, z=1
 *		     +----------- [wlx/wlx.y/wdsx.y]0.2 ------ x=1/2/3, y=0, z=2
 *		wl1 ------------ [wlx/wlx.y/wdsx.y]1.1 ------ x=1/2/3, y=1, z=1
 *		     +----------- [wlx/wlx.y/wdsx.y]1.2 ------ x=1/2/3, y=1, z=2
 *
 *		URE ON	: wds/mbss not support and wlx.y have same mac as wlx
 *		URE OFF	: wlx.y have unique mac and wdsx.y have same mac as wlx
 *
 */
int
get_spoof_mac(const char *osifname, char *mac, int maclen)
{
	char nvifname[16];
	int i, unit, subunit;
	wlif_name_desc_t *wlif_name;

	if (osifname == NULL ||
		mac == NULL ||
		maclen < ETHER_ADDR_LEN)
		return -1;
	if (osifname_to_nvifname(osifname, nvifname, sizeof(nvifname)) < 0)
		return -1;

	/* translate to spoof mac */
	if (!get_ifname_unit(nvifname, &unit, &subunit)) {
		memset(mac, 0, maclen);
		for (i = 0; i < ARRAYSIZE(wlif_name_array); i++) {
			wlif_name = &wlif_name_array[i];
			if (!strncmp(osifname, wlif_name->name, strlen(wlif_name->name))) {
				if (subunit >= 0 && wlif_name->subunit)
					break;
				else if (subunit < 0 && !wlif_name->subunit) {
					subunit = 0; /* reset to zero */
					break;
				}
			}
		}

		/* not found */
		if (i == ARRAYSIZE(wlif_name_array))
			return -1;

		/* translate it */
		mac[3] = i+1;
		mac[4] = unit;
		mac[5] = subunit;

		return 0;
	}

	return -1;
}

int
get_spoof_ifname(char *mac, char *osifname, int osifnamelen)
{
	int idx, unit, subunit;
	char nvifname[16];
	wlif_name_desc_t *wlif_name;

	if (osifname == NULL ||
		mac == NULL)
		return -1;

	if (mac[0] != 0 || mac[1] != 0 ||
		mac[2] != 0)
		return -1; /* is a real mac, fast check */

	idx = mac[3];
	idx --; /* map to wlif_name_array index */
	unit = mac[4];
	subunit = mac[5];
	if (idx < 0 || idx >= ARRAYSIZE(wlif_name_array))
		return -1;

	/* get nvname format */
	wlif_name = &wlif_name_array[idx];
	if (wlif_name->subunit)
		snprintf(nvifname, sizeof(nvifname), "%s%d.%d", (wlif_name->wds) ? "wds" : "wl",
		              unit, subunit);
	else
		snprintf(nvifname, sizeof(nvifname), "wl%d", unit);

	/* translate to osifname */
	if (nvifname_to_osifname(nvifname, osifname, osifnamelen) < 0)
		return -1;

	return 0;
}

int
get_real_mac(char *mac, int maclen)
{
	int idx, unit, subunit;
	char *ptr, ifname[32];
	wlif_name_desc_t *wlif_name;

	if (mac == NULL ||
	    maclen < ETHER_ADDR_LEN)
		return -1;

	if (mac[0] != 0 || mac[1] != 0 ||
		mac[2] != 0)
		return 0; /* is a real mac, fast path */

	idx = mac[3];
	idx --; /* map to wlif_name_array index */
	unit = mac[4];
	subunit = mac[5];
	if (idx < 0 || idx >= ARRAYSIZE(wlif_name_array))
		return -1;

	/* get wlx.y mac addr */
	wlif_name = &wlif_name_array[idx];
	if (wlif_name->subunit && !wlif_name->wds)
		snprintf(ifname, sizeof(ifname), "wl%d.%d_hwaddr", unit, subunit);
	else
		snprintf(ifname, sizeof(ifname), "wl%d_hwaddr", unit);

	ptr = nvram_get(ifname);
	if (ptr == NULL)
		return -1;

	ether_atoe(ptr, mac);
	return 0;
}

unsigned char *
get_wlmacstr_by_unit(char *unit)
{
	char tmptr[] = "wlXXXXX_hwaddr";
	char *macaddr;

	sprintf(tmptr, "wl%s_hwaddr", unit);

	macaddr = nvram_get(tmptr);

	if (!macaddr)
		return NULL;

	return macaddr;
}

int
get_lan_mac(unsigned char *mac)
{
	unsigned char *lanmac_str = nvram_get("lan_hwaddr");

	if (mac)
		memset(mac, 0, 6);

	if (!lanmac_str || mac == NULL)
		return -1;

	ether_atoe(lanmac_str, mac);

	return 0;
}

int
get_wlname_by_mac(unsigned char *mac, char *wlname)
{
	char eabuf[18];
	char tmptr[] = "wlXXXXX_hwaddr";
	char *wl_hw;
	int i, j;

	ether_etoa(mac, eabuf);
	/* find out the wl name from mac */
	for (i = 0; i < WLIFU_MAX_NO_BRIDGE; i++) {
		sprintf(wlname, "wl%d", i);
		sprintf(tmptr, "wl%d_hwaddr", i);
		wl_hw = nvram_get(tmptr);
		if (wl_hw) {
			if (!strncasecmp(wl_hw, eabuf, sizeof(eabuf)))
				return 0;
		}

		for (j = 1; j < WL_MAXBSSCFG; j++) {
			sprintf(wlname, "wl%d.%d", i, j);
			sprintf(tmptr, "wl%d.%d_hwaddr", i, j);
			wl_hw = nvram_get(tmptr);
			if (wl_hw) {
				if (!strncasecmp(wl_hw, eabuf, sizeof(eabuf)))
					return 0;
			}
		}
	}

	return -1;
}

/*
 * Get LAN or WAN ifname by wl mac
 * NOTE: We pass ifname in case of same mac in vifs (like URE TR mode)
 */
char *
get_ifname_by_wlmac(unsigned char *mac, char *name)
{
	char nv_name[16], os_name[16], if_name[16];
	char tmptr[] = "lanXX_ifnames";
	char *ifnames, *ifname;
	int i;

	/*
	  * In case of URE mode, wl0.1 and wl0 have same mac,
	  * we need extra identity (name).
	  */
	if (name && !strncmp(name, "wl", 2))
		snprintf(nv_name, sizeof(nv_name), "%s", name);
	else if (get_wlname_by_mac(mac, nv_name))
		return 0;

	if (nvifname_to_osifname(nv_name, os_name, sizeof(os_name)) < 0)
		return 0;

	if (osifname_to_nvifname(os_name, nv_name, sizeof(nv_name)) < 0)
		return 0;

	/* find for lan */
	for (i = 0; i < WLIFU_MAX_NO_BRIDGE; i++) {
		if (i == 0) {
			ifnames = nvram_get("lan_ifnames");
			ifname = nvram_get("lan_ifname");
			if (ifname) {
				/* the name in ifnames may nvifname or osifname */
				if (find_in_list(ifnames, nv_name) ||
				    find_in_list(ifnames, os_name))
					return ifname;
			}
		}
		else {
			sprintf(if_name, "lan%d_ifnames", i);
			sprintf(tmptr, "lan%d_ifname", i);
			ifnames = nvram_get(if_name);
			ifname = nvram_get(tmptr);
			if (ifname) {
				/* the name in ifnames may nvifname or osifname */
				if (find_in_list(ifnames, nv_name) ||
				    find_in_list(ifnames, os_name))
					return ifname;
			}
		}
	}

	/* find for wan  */
	ifnames = nvram_get("wan_ifnames");
	ifname = nvram_get("wan0_ifname");
	/* the name in ifnames may nvifname or osifname */
	if (find_in_list(ifnames, nv_name) ||
	    find_in_list(ifnames, os_name))
		return ifname;

	return 0;
}

#define CHECK_NAS(mode) ((mode) & (WPA_AUTH_UNSPECIFIED | WPA_AUTH_PSK | \
				   WPA2_AUTH_UNSPECIFIED | WPA2_AUTH_PSK))
#define CHECK_PSK(mode) ((mode) & (WPA_AUTH_PSK | WPA2_AUTH_PSK))
#define CHECK_RADIUS(mode) ((mode) & (WPA_AUTH_UNSPECIFIED | WLIFU_AUTH_RADIUS | \
				      WPA2_AUTH_UNSPECIFIED))

#if 0
/*
 * wl_wds<N> is authentication protocol dependant.
 * when auth is "psk":
 *	wl_wds<N>=mac,role,crypto,auth,ssid,passphrase
 */
bool
get_wds_wsec(int unit, int which, unsigned char *mac, char *role,
             char *crypto, char *auth, ...)
{
	char name[] = "wlXXXXXXX_wdsXXXXXXX", value[1000], *next;

	snprintf(name, sizeof(name), "wl%d_wds%d", unit, which);
	strncpy(value, nvram_safe_get(name), sizeof(value));
	next = value;

	/* separate mac */
	strcpy((char *)mac, strsep(&next, ","));
	if (!next)
		return FALSE;

	/* separate role */
	strcpy(role, strsep(&next, ","));
	if (!next)
		return FALSE;

	/* separate crypto */
	strcpy(crypto, strsep(&next, ","));
	if (!next)
		return FALSE;

	/* separate auth */
	strcpy(auth, strsep(&next, ","));
	if (!next)
		return FALSE;

	if (!strcmp(auth, "psk")) {
		va_list va;

		va_start(va, auth);

		/* separate ssid */
		strcpy(va_arg(va, char *), strsep(&next, ","));
		if (!next)
			goto fail;

		/* separate passphrase */
		strcpy(va_arg(va, char *), next);

		va_end(va);
		return TRUE;
fail:
		va_end(va);
		return FALSE;
	}

	return FALSE;
}
#endif	// 0

/* Get wireless security setting by interface name */
int
get_wsec(wsec_info_t *info, char *mac, char *osifname)
{
	int unit, wds = 0, wds_wsec = 0;
	char nv_name[16], os_name[16], wl_prefix[16], comb[32], key[8];
	char wds_role[8], wds_ssid[48], wds_psk[80], wds_akms[16], wds_crypto[16],
	        remote[ETHER_ADDR_LEN];
	char akm[16], *akms, *akmnext, *value, *infra;

	if (info == NULL || mac == NULL)
		return WLIFU_ERR_INVALID_PARAMETER;

	if (nvifname_to_osifname(osifname, os_name, sizeof(os_name))) {
		if (get_wlname_by_mac(mac, nv_name))
			return WLIFU_ERR_INVALID_PARAMETER;
		else if (nvifname_to_osifname(nv_name, os_name, sizeof(os_name)))
			return WLIFU_ERR_INVALID_PARAMETER;
	}
	else if (osifname_to_nvifname(os_name, nv_name, sizeof(nv_name)))
			return WLIFU_ERR_INVALID_PARAMETER;

	/* check if i/f exists and retrieve the i/f index */
	if (wl_probe(os_name) ||
		wl_ioctl(os_name, WLC_GET_INSTANCE, &unit, sizeof(unit)))
		return WLIFU_ERR_NOT_WL_INTERFACE;

	/* get wl_prefix */
	if (strstr(os_name, "wds")) {
		/* the wireless interface must be configured to run NAS */
		snprintf(wl_prefix, sizeof(wl_prefix), "wl%d", unit);
		wds = 1;
	}
	else if (osifname_to_nvifname(os_name, wl_prefix, sizeof(wl_prefix)))
		return WLIFU_ERR_INVALID_PARAMETER;

	strcat(wl_prefix, "_");
	memset(info, 0, sizeof(wsec_info_t));

	/* get wsd setting */
	if (wds) {
		/* remote address */
		if (wl_ioctl(os_name, WLC_WDS_GET_REMOTE_HWADDR, remote, ETHER_ADDR_LEN))
			return WLIFU_ERR_WL_REMOTE_HWADDR;
		memcpy(info->remote, remote, ETHER_ADDR_LEN);
#if 0
		int i;
		/* get per wds settings */
		for (i = 0; i < MAX_NVPARSE; i ++) {
			char macaddr[18];
			uint8 ea[ETHER_ADDR_LEN];

			if (get_wds_wsec(unit, i, macaddr, wds_role, wds_crypto, wds_akms, wds_ssid,
			                 wds_psk) &&
			    ((ether_atoe(macaddr, ea) && !bcmp(ea, remote, ETHER_ADDR_LEN)) ||
			     (!strcmp(mac, "*")))) {
			     /* found wds settings */
			     wds_wsec = 1;
			     break;
			}
		}
#endif	// 0
	}

	/* interface unit */
	info->unit = unit;
	/* interface os name */
	strcpy(info->osifname, os_name);
	/* interface address */
	memcpy(info->ea, mac, ETHER_ADDR_LEN);
	/* ssid */
	if (wds && wds_wsec)
		strncpy(info->ssid, wds_ssid, MAX_SSID_LEN);
	else {
		value = nvram_safe_get(strcat_r(wl_prefix, "ssid", comb));
		strncpy(info->ssid, value, MAX_SSID_LEN);
	}
	/* auth */
	if (nvram_match(strcat_r(wl_prefix, "auth", comb), "1"))
		info->auth = 1;
	/* nas auth mode */
	value = nvram_safe_get(strcat_r(wl_prefix, "auth_mode", comb));
	info->akm = !strcmp(value, "radius") ? WLIFU_AUTH_RADIUS : 0;
	if (wds && wds_wsec)
		akms = wds_akms;
	else
		akms = nvram_safe_get(strcat_r(wl_prefix, "akm", comb));
	foreach(akm, akms, akmnext) {
		if (!strcmp(akm, "wpa"))
			info->akm |= WPA_AUTH_UNSPECIFIED;
		if (!strcmp(akm, "psk"))
			info->akm |= WPA_AUTH_PSK;
		if (!strcmp(akm, "wpa2"))
			info->akm |= WPA2_AUTH_UNSPECIFIED;
		if (!strcmp(akm, "psk2"))
			info->akm |= WPA2_AUTH_PSK;
	}
	/* wsec encryption */
	value = nvram_safe_get(strcat_r(wl_prefix, "wep", comb));
	info->wsec = !strcmp(value, "enabled") ? WEP_ENABLED : 0;
	if (wds && wds_wsec)
		value = wds_crypto;
	else
		value = nvram_safe_get(strcat_r(wl_prefix, "crypto", comb));
	if (CHECK_NAS(info->akm)) {
		if (!strcmp(value, "tkip"))
			info->wsec |= TKIP_ENABLED;
		else if (!strcmp(value, "aes"))
			info->wsec |= AES_ENABLED;
		else if (!strcmp(value, "tkip+aes"))
			info->wsec |= TKIP_ENABLED|AES_ENABLED;
	}
	/* nas role setting, may overwrite later in wds case */
	value = nvram_safe_get(strcat_r(wl_prefix, "mode", comb));
	infra = nvram_safe_get(strcat_r(wl_prefix, "infra", comb));
	if (!strcmp(value, "ap")) {
		info->flags |= WLIFU_WSEC_AUTH;
	}
	else if (!strcmp(value, "sta") || !strcmp(value, "wet")) {
		if (!strcmp(infra, "0")) {
			/* IBSS, so we must act as Authenticator and Supplicant */
			info->flags |= WLIFU_WSEC_AUTH;
			info->flags |= WLIFU_WSEC_SUPPL;
			/* Adhoc Mode */
			info->ibss = TRUE;
		}
		else {
			info->flags |= WLIFU_WSEC_SUPPL;
		}
	}
	else if (!strcmp(value, "wds")) {
		;
	}
	else {
		/* Unsupported network mode */
		return WLIFU_ERR_NOT_SUPPORT_MODE;
	}
	/* overwrite flags */
	if (wds) {
		unsigned char buf[32], *ptr, lrole;

		/* did not find WDS link configuration, use wireless' */
		if (!wds_wsec)
			strcpy(wds_role, "auto");

		/* get right role */
		if (!strcmp(wds_role, "sup"))
			lrole = WL_WDS_WPA_ROLE_SUP;
		else if (!strcmp(wds_role, "auth"))
			lrole = WL_WDS_WPA_ROLE_AUTH;
		else /* if (!strcmp(wds_role, "auto")) */
			lrole = WL_WDS_WPA_ROLE_AUTO;

		strcpy(buf, "wds_wpa_role");
		ptr = buf + strlen(buf) + 1;
		bcopy(info->remote, ptr, ETHER_ADDR_LEN);
		ptr[ETHER_ADDR_LEN] = lrole;
		if (wl_ioctl(os_name, WLC_SET_VAR, buf, sizeof(buf)))
			return WLIFU_ERR_WL_WPA_ROLE;
		else if (wl_ioctl(os_name, WLC_GET_VAR, buf, sizeof(buf)))
			return WLIFU_ERR_WL_WPA_ROLE;
		lrole = *buf;

		/* overwrite these flags */
		info->flags = WLIFU_WSEC_WDS;
		if (lrole == WL_WDS_WPA_ROLE_SUP) {
			info->flags |= WLIFU_WSEC_SUPPL;
		}
		else if (lrole == WL_WDS_WPA_ROLE_AUTH) {
			info->flags |= WLIFU_WSEC_AUTH;
		}
		else {
			/* unable to determine WPA role */
			return WLIFU_ERR_WL_WPA_ROLE;
		}
	}
	/* user-supplied psk passphrase */
	if (CHECK_PSK(info->akm)) {
		if (wds && wds_wsec) {
			strncpy((char *)info->psk, wds_psk, MAX_USER_KEY_LEN);
			info->psk[MAX_USER_KEY_LEN] = 0;
		}
		else {
			value = nvram_safe_get(strcat_r(wl_prefix, "wpa_psk", comb));
			strncpy((char *)info->psk, value, MAX_USER_KEY_LEN);
			info->psk[MAX_USER_KEY_LEN] = 0;
		}
	}
	/* user-supplied radius server secret */
	if (CHECK_RADIUS(info->akm))
		info->secret = nvram_safe_get(strcat_r(wl_prefix, "radius_key", comb));
	/* AP specific settings */
	value = nvram_safe_get(strcat_r(wl_prefix, "mode", comb));
	if (!strcmp(value, "ap")) {
		/* gtk rekey interval */
		if (CHECK_NAS(info->akm)) {
			value = nvram_safe_get(strcat_r(wl_prefix, "wpa_gtk_rekey", comb));
			info->gtk_rekey_secs = (int)strtoul(value, NULL, 0);
		}
		/* wep key */
		if (info->wsec & WEP_ENABLED) {
			/* key index */
			value = nvram_safe_get(strcat_r(wl_prefix, "key", comb));
			info->wep_index = (int)strtoul(value, NULL, 0);
			/* key */
			sprintf(key, "key%s", nvram_safe_get(strcat_r(wl_prefix, "key", comb)));
			info->wep_key = nvram_safe_get(strcat_r(wl_prefix, key, comb));
		}
		/* radius server host/port */
		if (CHECK_RADIUS(info->akm)) {
			/* update radius server address */
			info->radius_addr = nvram_safe_get(strcat_r(wl_prefix, "radius_ipaddr",
			                                            comb));
			value = nvram_safe_get(strcat_r(wl_prefix, "radius_port", comb));
			info->radius_port = htons((int)strtoul(value, NULL, 0));
			/* 802.1x session timeout/pmk cache duration */
			value = nvram_safe_get(strcat_r(wl_prefix, "net_reauth", comb));
			info->ssn_to = (int)strtoul(value, NULL, 0);
		}
	}
	/* preauth */
	value = nvram_safe_get(strcat_r(wl_prefix, "preauth", comb));
	info->preauth = (int)strtoul(value, NULL, 0);

	/* verbose */
	value = nvram_safe_get(strcat_r(wl_prefix, "nas_dbg", comb));
	info->debug = (int)strtoul(value, NULL, 0);

	return WLIFU_WSEC_SUCCESS;
}

