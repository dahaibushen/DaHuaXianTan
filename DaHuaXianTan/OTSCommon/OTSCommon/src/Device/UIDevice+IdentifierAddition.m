//
//  UIDevice(Identifier).m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import "UIDevice+IdentifierAddition.h"
#import "NSString+MD5.h"
#import "Foundation+Safe.h"
#import "OTSKeychain.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define MAXADDRS 32
#define BUFFERSIZE 4000
#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))

static void InitAddresses(void);

static void FreeAddresses(void);

static void GetIPAddresses(void);

extern char *ip_names[MAXADDRS];

NSString *const OTS_EYCHAIN_DEVICECODE_KEY = @"OTS_KEYCHAIN_DEVICECODE";

@implementation UIDevice (IdentifierAddition)

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *)macaddress {

    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }

    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }

    ifm = (struct if_msghdr *) buf;
    sdl = (struct sockaddr_dl *) (ifm + 1);
    ptr = (unsigned char *) LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                                     *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    free(buf);
    return outstring;
}

- (NSString *)uniqueDeviceIdentifier {
    NSString *code = nil;
    NSString *keyChain_deviceCode = [OTSKeychain getKeychainValueForType:OTS_EYCHAIN_DEVICECODE_KEY];
    if (keyChain_deviceCode == nil || keyChain_deviceCode.length < 10) {  // 若keychain里面没有或者长度因为什么原因很短的话，重新获取一次再储存
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            code = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        } else {
            code = [NSString safeStringWithString:[[UIDevice currentDevice] macaddress]];
        }
        [OTSKeychain setKeychainValue:code forType:OTS_EYCHAIN_DEVICECODE_KEY];
    } else {
        code = keyChain_deviceCode;
    }

    return code;
}

- (NSString *)uniqueGlobalDeviceIdentifier {
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *uniqueIdentifier = macaddress.md5String;

    return uniqueIdentifier;
}

+ (BOOL)isJailBreak {
    static BOOL isJailBreak = NO;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = @[@"/Applications/Cydia.app",
                @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                @"/bin/bash",
                @"/usr/sbin/sshd",
                @"/etc/apt"];
        for (NSString *path  in paths) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                isJailBreak = YES;
                break;
            }
        }
    });

    return isJailBreak;
}

- (NSString *)ipAddress {
    InitAddresses();
    GetIPAddresses();
    NSString *addr = [NSString stringWithFormat:@"%s", ip_names[1]];
    FreeAddresses();
    return addr;
}

@end

char *if_names[MAXADDRS];
char *ip_names[MAXADDRS];
unsigned long ip_addrs[MAXADDRS];

int nextAddr;

static void InitAddresses() {
    int i;
    for (i = 0; i < MAXADDRS; ++i) {
        if_names[i] = ip_names[i] = NULL;
        ip_addrs[i] = 0;
    }
    nextAddr = 0;
}

static void FreeAddresses() {
    int i;
    for (i = 0; i < MAXADDRS; ++i) {
        if (if_names[i] != 0) free(if_names[i]);
        if (ip_names[i] != 0) free(ip_names[i]);
        ip_addrs[i] = 0;
    }

    InitAddresses();
}

static void GetIPAddresses() {
    int i, len, flags;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifconf ifc;
    struct ifreq *ifr, ifrcopy;
    struct sockaddr_in *sin;
    char temp[80];
    int sockfd;
    for (i = 0; i < MAXADDRS; ++i) {
        if_names[i] = ip_names[i] = NULL;
        ip_addrs[i] = 0;
    }

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("socket failed");
        return;
    }

    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0) {
        perror("ioctl error");
        return;
    }
    lastname[0] = 0;
    for (ptr = buffer; ptr < buffer + ifc.ifc_len;) {
        ifr = (struct ifreq *) ptr;
        len = max(sizeof(struct sockaddr), ifr->ifr_addr.sa_len);
        ptr += sizeof(ifr->ifr_name) + len; // for next one in buffer
        if (ifr->ifr_addr.sa_family != AF_INET) {
            continue; // ignore if not desired address family
        }

        if ((cptr = (char *) strchr(ifr->ifr_name, ':')) != NULL) {
            *cptr = 0; // replace colon will null
        }

        if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) {
            continue; /* already processed this interface */
        }
        memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
        ifrcopy = *ifr;
        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
        flags = ifrcopy.ifr_flags;
        if ((flags & IFF_UP) == 0) {
            continue; // ignore if interface not up
        }
        if_names[nextAddr] = (char *) malloc(strlen(ifr->ifr_name) + 1);
        if (if_names[nextAddr] == NULL) {
            return;
        }

        strcpy(if_names[nextAddr], ifr->ifr_name);
        sin = (struct sockaddr_in *) &ifr->ifr_addr;
        strcpy(temp, inet_ntoa(sin->sin_addr));
        ip_names[nextAddr] = (char *) malloc(strlen(temp) + 1);

        if (ip_names[nextAddr] == NULL) {
            return;
        }
        strcpy(ip_names[nextAddr], temp);
        ip_addrs[nextAddr] = sin->sin_addr.s_addr;
        ++nextAddr;
    }

    close(sockfd);
}
