--- yaml
layout: 'article'
title: 'PAC: proxy auto-config'
author: 'Changwoo Park, Sean Lee'
date: '2012-1-8'
tags: ['PAC', 'proxy', 'auto-config', 'freegate]
---

Proxy을 통해 우회하고 싶을 때가 왕왕 있다.

중국이나 한국같은 인터넷 통제국을 여행한다거나. 인터넷 통제회사에서 일을 한다거나. 특정 ip에서만 접근 가능한 사이트에 접근하고 싶을 때도 있고, 논문을 조회해야 하는데 이런건 학교에서만 무료라서 학교를 통해야 한다든지. 어쨌든 이런게 가끔식 필요할 때가 있다.

보통은 사무실에서 인터넷을 엉터리로 막아서 일하는데 필요한 사이트를 들어가기 위해 사용한다. 이글을 쓰는 시점에서는 Oracle Technet에서 다운받으려면 인증해야 하는데 HTTPS를 막아서 인증을 할 수가 없었다.

![pacman](/articles/2012/proxy-auto-config/pacman.gif)

이 설정은 Window에서만 확인했다.

## PAC(Proxy Auto-Config) 파일

아무튼 규칙이 2~3개만 되도 헷갈리고 관리하기 쉽지 않다. 그냥 프로토콜이 무엇인지, ip가 무엇인지, 도메인지 무엇인지에 따라 규칙을 만들고 활용하면 좋을 것이다. PAC 파일을 만들어 사용하면 규칙을 스크립트로 관리할 수 있다.

PAC는 아주 간단한 파일이다:

    function FindProxyForURL(url, host) {

        url = url.toLowerCase();
        host = host.toLowerCase();
        hostip=dnsResolve(host);
        isHttp=(url.substring(0,5) == "http:");
        isHttps=(url.substring(0,6) == "https:")

        // 로컬은 항상 DIRECT로 접근한다.
        if(0
            || isPlainHostName(host)
            || isInNet(hostip, "10.0.0.0", "255.0.0.0") 
            || isInNet(hostip, "172.16.0.0", "255.240.0.0") 
            || isInNet(hostip, "192.168.0.0", "255.255.0.0")
            ) { 
            return "DIRECT"; 
        }

        // Https가 필요한데, 접근을 막혔다.
        if(isHttps) {
            //먼저 SOCKS PROXY를 통하고 실패하면 그냥 연결한다.
            return "SOCKS 127.0.0.1:8580; DIRECT";
        }

        // dropbox도 막았다.
        if (shExpMatch(url, "http://www.dropbox.com*")) {
            //이건 HTTP PROXY로 연결하고 실패하면 그냥 연결한다.
            return "PROXY 127.0.0.1:8580; DIRECT";
        }

        return "DIRECT"; 
    }

파일 이름은 상관없지만 그래도 PAC파일임을 알 수 있게 my.pac쯤으로 짓는다.

그리고 Explorer에서 "Internet Options/Connections/LAN settings"에서 my.pac파일을 지정해줄 수 있다:

![my.pac](/articles/2012/proxy-auto-config/pac.png)

## Browser

그러면 이제 저 규칙을 따라 동작한다. 브라우저별로 보면 Explorer/Firefox/Opera는 각각 별도로 설정할 수 있다. 그래서 굳이 PAC를 사용하지 말고 브라우저 별로 다르게 설정해서 필요에 따라 다른 브라우저를 선택해 사용하는 것도 방법이다.

그리고 Chrome은 System 설정을 사용하니까 Explorer와 같은 설정을 사용한다. 

## best practice

여러가지 방법을 시도해서 'best practice'를 찾았다. Chrome의 [Switchy][] Extension을 사용하는 것이 가장 편리하다. Switchy는 Proxy Profile을 만들고 Profile 사이를 쉽게 스위칭할 수 있게 해준다. Chrome은 시스템 설정을 사용하므로 Switchy에서 Profile을 변경하면 시스템 설정이 바뀐다.

Switchy + PAC 를 사용하면 바늘 구멍만 뚤려 있어도 인터넷을 비교적 편안하게 즐길 수 있다.

## 기타.

 * SSH tunnel은 SOCKS 프록시다.
 * 8580은 [freegate][] 기본 포트다.
 * freegate는 중국 여행 필수품; 공익재단이(라고 쓰고 '미국이' 라고 읽는다) 만든다. freegate는 무료 HTTPS Proxy로 인터넷 통제국을(이라고 쓰고 '중국을' 이라고 읽는다) 무력화할 목적으로 개발되고 있다. 인터넷 통제국으로 인정해주지 않은 나라에서는 사용할 수 없다. 그런데, 한국은 인터넷 통제국임에도 불구하고 freegate를 사용할 수 없다. 한국도 인정해달라!

[Switchy]: http://switchy.samabox.com/
[freegate]: http://en.wikipedia.org/wiki/Freegate

