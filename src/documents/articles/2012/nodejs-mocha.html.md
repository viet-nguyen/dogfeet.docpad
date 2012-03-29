--- yaml
layout: 'article'
title: 'nodejs: Mocha'
author: 'Changwoo Park'
date: '2012-4-8'
tags: ['nodejs', 'BDD', 'Test', 'Mocha', 'Should']
---

이 글은 '[Testing with Mocha][]'을 다시 쓴 것이다. [Alex Young][]님이 만든 예제도 내가 쓰기 편하게 좀 고쳤다.

![mocha-test](/articles/2012/nodejs-mocha/mocha-test.png)

[Testing with Mocha][]를 읽고 Mocha 메뉴얼을 읽으니 훨씬 눈에 잘들어 온다.

## Mocha

[Mocha][]는 TJ Holowaychuk이 만든 [BDD][] 프레임워크이다. [nodejs][]에서 [TDD][]를 할 때 사용하고 [vowjs][]와 함께 주목 받고 있는 모듈이다.

다양한 방법으로 리포팅하는 방법도 제공하고 암튼 좋다. 사실 vowjs는 안살펴봐서 모르겠다. 둘의 차이는 @drypot님의 [글][drypot-mocha]로 비교해보자.

[BDD]: http://en.wikipedia.org/wiki/Behavior_Driven_Development
[nodejs]: http://www.nodejs.org/
[TDD]: http://en.wikipedia.org/wiki/Test-driven_development
[vowjs]: http://vowsjs.org/
[drypot-mocha]: http://drypot.tumblr.com/post/17366382509/vows-vs-mocha

## package.json

먼저 package.json 파일을 다음과 같이 만든다.

    {
        "name": "async-testing-tutorial"
        , "version": "0.0.1"
        , "description": "A tutorial for Mocha"
        , "keywords": ["test", "tutorial"]
        , "author": "Alex R. Young <info@dailyjs.com>"
        , "main": "index"
        , "engines": { "node": ">= 0.4.x < 0.7.0" }
        , "scripts": {
            "test": "make test"
        }
        , "devDependencies": {
            "mocha": "1.0.x"
            , "should": "0.6.x"
        }
    }

원래 코드는 assert 모듈과 TDD 스타일로 돼있었지만, 나는 should와 BDD가 더 직관적이라고 생각하므로 바꿨다.

이를 위해 의존성을 추가한다: 

    , "devDependencies": {
        "mocha": "1.0.x"
        , "should": "0.6.x"
    }

이제 `npm install`하면 해당 모듈이 설치된다.

## Makefile

다음과 같이 Makefile을 만들고 `make test`를 실행하면 된다. 

    test:
        @./node_modules/.bin/mocha --require should

    .PHONY: test

 * `--require should` - 테스트 코드에서 should 모듈을 끼워 넣어 준다. 생략하면 테스트 코드에 `require('should')`를 직접 넣어 줘야 한다.
 * `--reporter dot` - 테스트 결과를 어떻게 보여줄지 reporter를 고를 수 있다. 생략시 기본 값은 `dot`.
 * `--u bdd` - 테스트 스타일을 고를 수 있는데. 생략시 기본 값은 `bdd`.

자세한 옵션은 [Mocha][] 페이지에서 확인한다.

## prime Module

[Alex Young][]님이 작성한 모듈 코드:

    function nextPrime(n) {
        var smaller;
        n = Math.floor(n);

        if (n >= 2) {
            smaller = 1;
            while (smaller * smaller <= n) {
                n++;
                smaller = 2;
                while ((n % smaller > 0) && (smaller * smaller <= n)) {
                    smaller++;
                }   
            }   
            return n;
        } else {
            return 2;
        }   
    }

    function asyncPrime(n, fn) {
        setTimeout(function() {
            fn( nextPrime(n) );
        }, 10);
    }

    module.exports.nextPrime = nextPrime;
    module.exports.asyncPrime = asyncPrime;


## Test

BDD 스타일로 작성한 테스트는 다음과 같다.

    var nextPrime = require('./../index').nextPrime
    var asyncPrime = require('./../index').asyncPrime;

    describe('prime', function() {

        describe('nextPrime', function() {

            it('nextPrime should return the next prime number', function() {
                nextPrime(7).should.equal(11);
            }); 

            it('zero and one are not prime numbers', function() {
                nextPrime(0).should.equal(2);
                nextPrime(1).should.equal(2);
            }); 
        }); 

        describe('asyncPrime', function() {

            it('asyncPrime should return the next prime number', function(done) {
                asyncPrime(128, function(n) {
                    n.should.equal(131);
                    done();
                });
            });
        });
    });

비동기 테스트 예제인 'asyncPrime'은 done()을 호출해서 테스트가 성공했음을 알린다.

## hooks

 * before() - describe()를 시작하기 전에 한번
 * after() - describe()를 끝내고나서 한번
 * beforeEach() - describe() 안에 있는 it()이 시작할 때마다 한번
 * afterEach() - describe() 안에 있는 it() 이 끝날 때마다 한번

위 테스트코드에 hooks을 추가해보고:

    var nextPrime = require('./../index').nextPrime
    var asyncPrime = require('./../index').asyncPrime;

    describe('prime', function() {

        before(function(){
            console.log('before');
        }); 

        after(function(){
            console.log('after');
        }); 

        beforeEach(function(){
            console.log('beforeEach');
        }); 

        afterEach(function(){
            console.log('afterEach');
        }); 

        describe('nextPrime', function() {
            before(function(){
                console.log('new before');
            }); 

            it('nextPrime should return the next prime number', function() {
                nextPrime(7).should.equal(11);
            }); 

            it('zero and one are not prime numbers', function() {
                nextPrime(0).should.equal(2);
                nextPrime(1).should.equal(2);
            }); 
        }); 

        describe('asyncPrime', function() {
            afterEach(function(){
                console.log('new afterEach');
            });

            it('asyncPrime should return the next prime number', function(done) {
                asyncPrime(128, function(n) {
                    n.should.equal(131);
                    done();
                });
            });
        });
    });

결과는 다음과 같다:

      before
    new before
    beforeEach
    .afterEach
    beforeEach
    .afterEach
    beforeEach
    .new afterEach
    afterEach
    after


      ✔ 3 tests complete (25ms)

'new afterEach'나 'new before' 부분에서 스택처럼 동작해서 상위 describe()에 정의한 것은 생략될까 싶었는데, 아니였다. 모두 호출된다.

[Alex Young][] 만든 코드는 [async-testing-tutorial][]이고 내가 수정한 코드는 [async-testing-tutorial-pismute][]이다.

TDD 스타일로 테스트를 작성하고 assert방식의 expecting을 선호한다면 [Alex Young][]만든 코드를 보는 것이 낫다.

[async-testing-tutorial]: https://github.com/alexyoung/async-testing-tutorial
[async-testing-tutorial-pismute]: https://github.com/pismute/async-testing-tutorial
[Mocha]: http://visionmedia.github.com/mocha/
[Testing with Mocha]: http://dailyjs.com/2011/12/08/mocha/
[Alex Young]: http://alexyoung.org/

