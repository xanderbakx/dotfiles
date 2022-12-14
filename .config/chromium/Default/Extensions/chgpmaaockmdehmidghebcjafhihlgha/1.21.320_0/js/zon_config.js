/* Javascript configuration */
'use strict'; /*jslint node:true*//*global define*/
var zon_config = {
"CONFIG_MAKEFLAGS": "DIST=APP RELEASE=y AUTO_SIGN=y",
"ARCH_CPU": "X86",
"BUILDTYPE_DEBUG": false,
"_RELEASE": true,
"_RELEASE_LEVEL": 2,
"ZON_VERSION": "1.21.320",
"ZON_VERSION_1": 1,
"ZON_VERSION_2": 21,
"ZON_VERSION_3": 320,
"ZON_COPYRIGHT_YEAR": "2016",
"SVC_EXE": "hola_svc",
"SVC_EXE_ANDROID": "libhola_svc.so",
"PLUGIN_EXE": "hola_plugin",
"PLUGIN_EXE_X64": "hola_plugin_x64",
"PLUGIN_NAME": "firefox_hola",
"CDN_SDK_FILE_NAME": "hola_cdn_sdk-1.21.320.tar.gz",
"CDN_DEMO_FILE_NAME": "hola_cdn_demo-1.21.320.apk",
"IMA_DEMO_FILE_NAME": "hola_ima_demo-1.21.320.apk",
"VA_FILE_NAME": "hola_va-1.21.320.apk",
"GPS_LOCATION_FILE_NAME": "hola_gps_location-1.21.320.apk",
"VPN_API_FILE_NAME": "hola_vpn_api-1.21.320.tar.gz",
"BEXT_CHROME_DLL_ID_REL": "pdehmppfilefbolgganhfihpbmjlgebh",
"BEXT_CHROME_ID_REL": "pnknnijoleibcpmkdcooclmnjmmdhgbg",
"BEXT_CHROME_CWS_ID_REL": "gkojfkhlekighikafcpjkiklfbnlmeio",
"BEXT_CHROME_CWS_PLUGIN_ID": "mhcmfkkjmkcfgelgdpndepmimbmkbpfp",
"BEXT_OPERA_ADDONS_ID_REL": "ekmmelpnmfdegjhnmadddcfjcahpajnm",
"BEXT_FF_ID_REL_SIGNED": "ff_ext@hola.org",
"BEXT_FF_ORIGIN_SIGNED": "resource://ff_ext-at-hola-dot-org",
"BEXT_FF_ID_REL": "jid1-4P0kohSJxU1qGg@jetpack",
"BEXT_FF_ORIGIN": "resource://jid1-4p0kohsjxu1qgg-at-jetpack",
"CONFIG_LOCAL_CCGI_CHROME": true,
"CONFIG_MP_CHROME": false,
"CONFIG_MP_TORCH": false,
"CONFIG_MP_OPERA": true,
"BEXT_PLUGIN": false,
"BEXT": 1,
"BEXT_VA_CHROME_ID_REL": "chgpmaaockmdehmidghebcjafhihlgha",
"HOLA_ADBLOCK_ID_REL": "lalfpjdbhpmnhfofkckdpkljeilmogfl"
};
if (typeof module=='object'&&module&&module.exports)
    module.exports = zon_config;else if (typeof define=='function') define(zon_config);
