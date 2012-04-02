--- yaml
layout: 'article'
title: 'Git: git-svn'
author: 'Changwoo Park'
date: '2012-4-25'
tags: ['git', 'svn']
---

'git-svn'에서 쓸만한 명령어를 정리했다. svn server + git client 같이 오묘한 조합은 사용하고 싶지 않았는데, 너무 불편해서 못살겠다.

잉여덕 GitHub는 [git server + hg client][hg-git], [git server + svn client][svn-git] 조합도 만들었는데 쓰는 사람이 있는지 궁금하다.

## 주요 명령어 정리

svn 브랜치를 직접조작하거나, SVN처럼 로그를 보거나 등등의 기능이 많지만 어짜피 안쓸거라서 기억하고 싶지 않다. SVN을 Git으로 마이그레이션할 때 필요하긴 한데, 그래야 할 날이 오지 않길 바란다--;쿨럭.

### clone:

    git svn clone url -s

-s는 표준레이아웃인 `trunk, branches, tags`를 사용한다는 의미다. 표준레이아웃을 사용하지 않으면 `-T trunk -b branches -t tags`라고 직접 알려주면 된다.

trunk, branches, tags는 모두 Git 브랜치로 만들어진다. trunk와 branches는 같은 이름으로 만들어지지만 tags는 앞에 `tags/`라고 붙는다.

progit 책에 나오는 `http://progit-example.googlecode.com/svn/`을 적용해보면 다음과 같이 만들어진다:

    └─▪ git br -av
    * master                        5925d95 Support HP C++ on Tru64.
      remotes/my-calc-branch        a52ad75 created a branch
      remotes/tags/2.0.2            fd8e73e Tag release 2.0.2.
      remotes/tags/release-2.0.1    60feb5c Tag the 2.0.1 release.
      remotes/tags/release-2.0.2    85bac46 Set version to 2.0.2 in release branch.
      remotes/tags/release-2.0.2rc1 168051e Update version number in 2.0.2rc1 release branch.
      remotes/trunk                 5925d95 Support HP C++ on Tru64

### fetch:

`git fetch`에 대응되는 명령어:

    git svn fetch

`git pull`되는 명령어가 필요한데 못 찾겠다. trunk가 master로 자동으로 Fast-Forward Merge됐으면 좋겠다. 

`git-svn` 프로젝트이면 trunk를 master로 Fast-Forware Merge하도록 [git-ff][]를 수정했다. 이 브랜치만 Merge한다. svn에서 브랜치를 쓰고 싶지 않다.

### push:

`git push`에 대응하는 명령어:

    git svn dcommit

svn은 히스토리가 평평하니까 이것만 주의하면 된다.

### .gitignore:

.gitignore를 만들어 넣으면 svn 서버에 Push된다. 다른 사람 몰래 혼자 쓰고 싶으면 `.git/info/exclude`에 만들면된다. .gitignore랑 똑같고 해당 저장소에만 적용되며 Push할 수 없다:

    git svn show-ignore > .git/info/exclude

### annotate:

어떤 넘이 잘못 고쳤는지 찾아보는 명령어:

    git svn blame [FILE] 

[git-ff]: https://github.com/pismute/git-tles
[hg-git]: http://hg-git.github.com/
[svn-git]: https://github.com/blog/966-improved-subversion-client-support
