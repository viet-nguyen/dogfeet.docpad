--- yaml
layout: 'article'
title: 'nodejs: nvm upgrade 연속기'
author: 'Changwoo Park, Sean Lee'
date: '2012-1-8'
tags: ['nodejs', 'nvm', '연속기', 'help']
---

nvm으로 node 버전을 관리하면 굉장히 편리하다. 하지만 node 버전은 죽죽죽 죽죽죽 자라나는 데다가 한번 버전을 올리려면 `nvm 연속기`를 날리는게 귀찮다.

![ken](/articles/2012/nodejs-nvm/ken-waryoken.jpeg)

## nvm 연속기

다음과 같은 `nvm 연속기`를 시전 해야 한다:

 * nvm install [new version] - 새 버전을 설치하고
 * nvm alias default [new version] - 새로 alias를 등록하고
 * nvm use default - 새버전을 사용한다.
 * nvm copy-packages [old version] - 전 버전에 설치된 module을 모두 새 버전으로 복사한다.
 * 그리고 `nvm link`로 global에 설치한 개발 모듈을 다시 설치한다.

### Bash 스크립트.

nvm 연속기를 Bash 스크립트로 한방에 실행할 수 있다:

    function nvm-upgrade () {
      local ver=$1

      if [ "$ver" = "" ]; then
        echo "usage: nvm-install v6.9.10";
      else
        ## download, build, install
        local failed=`echo $(nvm install $ver | grep "nvm: install $ver failed!")`

        if [ "$failed" != "" ]; then
          echo $failed
        else
          ## mark previous version
          local pre_ver=`node -v`
          if [ "$pre_ver" != "" ]; then
            nvm alias pre-default $pre_ver
          fi  

          ##change version
          nvm alias default $ver
          nvm use default

          ## copy modules has already
          nvm copy-packages pre-default

          ## re-install module-in-dev into global
          local links=`ls -al ~/.nvm/$pre_ver/lib/node_modules | grep "^l" | awk '{print $9}'`

          local cwd=`pwd`

          for link in $links; do
            cd ~/.nvm/$pre_ver/lib/node_modules/$link
            npm link
          done;

          cd $cwd
        fi
      fi
    }

