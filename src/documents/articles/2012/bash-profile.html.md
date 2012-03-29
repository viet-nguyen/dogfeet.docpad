--- yaml
layout: 'article'
title: 'Bash: .profile, .bash_profile, .bashrc'
author: 'Changwoo Park'
date: '2012-4-8'
tags: ['Bash', '.profile', '.bash_profile', .bashrc']
---

닭 대가리라 필요할 때마다 Google님께 물어 보는 것이 '.profile, .bash_profile, .bashrc'의 차이다.

## Ubuntu

최근 업무에 X windows가 필요해서 백년만에 ubuntu Desktop을 vmware에 설치했는데, 이거 왠 걸 쓸만하다. 적어도 Windows 보다 편하다. 회사에서 보안프로그램만 지원해주면 업무용으로 그냥 Ubuntu Desktop를 쓰고 싶다.

이제 돈받고 팔아도 되겠다. 12.04가 기대된다. 설치도, 내 취향에 맞춘 설정까지 하루밖에 안 걸린다.

이 글의 주인공은 Ubuntu이고 조연은 Mac이다.

## Login Shell vs Non-login Shell

먼저 'Login Shell'과 'Non-login Shell' 을 구분해야 하는데, 로그인은 계정과 암호를 입력해서 Shell을 실행하는 것이다. ssh로 접속하거나 로컬에서 GUI에서 로그인 한다는 의미다.

'.profile', '.bash_profile'이 Login할 때 로드되는(source) 파일이다. '.profile'은 꼭 bash가 아니더라도 로그인하면 로드되고 '.bash_profile'은 꼭 Bash로 Login할 때 로드된다.

그리고 'Non-login Shell'은 로그인 없이 실행하는 Shell을 말한다. ssh로 접속한 후에 다시 bash를 실행하는 겅우나. GUI 세션에서 터미널을 띄우는 것이 이해 해당한다. 'sudo bash'나 'su' 같은 것도 이에 해당한다.

'.bashrc'는 로그인 없이 Bash가 실행될 때 로드된다. 'sudo bash'나 'su'로 root 권한을 얻으려 bash를 실행할 때도 이 파일이 로드된다.

정리:

 * '.profile' - 로그인 할 때 로드된다. PATH처럼 로그인 할때 로드해야 하는데 bash와 상관없는 것들을 여기에 넣는다.
 * '.bash_profile' - 로그인 할 때 로드된다. 'bash completion'이나 'nvm'같이 로그인 할 때 로드해야 하는데 Bash와 관련된 것이면 여기에 넣는다. 
 * '.bashrc' - 로그인하지 않고 Bash가 실행될 때 로드된다.

## bash-it

나는 Bash 프레임워크인 [bash-it][]을 사용하는데, 그냥 터미널에서 ssh로 접속하기만 할 때는 '.bash_profile'에만 넣어주는 걸로 충분했다. 그런데 Desktop으로 쓸려니 로그인 없이 Bash를 실행할 일이 많아서 '.bashrc'에 넣어줘야 했다:

    if [ -f "~/.bash_profile" ]; then
        . ~/.bash_profile
    fi

그런데 'sudo bash'를 실행할 때도 bash-it이 로드되서 root가 아닐때만 로드되게 했다:

    if [ "$USER" != "root" ] && [ -f "~/.bash_profile" ]; then
        . ~/.bash_profile
    fi

꼭 터미널을 열고 Bash를 띄울 때만 bash-it을 사용하고 싶은데 GUI 세션에 로그인할 때도 실행되는 느낌이다. 이것도 확인해봐야 하는데,,,

## Mac

사실 Mac에서 한 번도 'Login Bash'같은 컨셉에 대해 생각해본 적 없다. 그러니까 Bash를 실행해할 때 로그인해 본적이 없다. Mac에 ssh로 접속한 적이 없다. 그러니까 Mac에서는 .bash_profile과 .bashrc를 구분해 사용하려는 생각을 한적이 없다.

그래서 더 헷갈린다. Mac에서는 터미널을 열어도 '.bash_profile'이 로드된다. 'sudo bash'할 때나 그냥 'bash'를 실행시켰을 때에는 로드하지 않는 것으로 봐서 여지것 얘기한 것에서 크게 벗어나는 것 같진 않다. 그냥 조금 다르다.

이를 테면 '터미널을 연다는 것은 로그인하면서 Bash를 실행시키는 것'라고 보면 된다. 터미널을 열 때에도 '.bash_profile'이 로드되지만 bash를 그냥 실행시킬 때는 '.bash_profile'은 로드하지 않는다.

뭔가 수상하다. 뭐든 해봐야 알 것 같고 답에 문제를 맟추는 것 같다. 혼란스럽다. 가카리즘에 빠져 버렸다.

## .bash_login, .bash_logout, .bash_complete ...

그외 많은 파일들이 있는데 별로 중요하지도 않고 필요 없을 것 같아서 정리하지 않았다.

