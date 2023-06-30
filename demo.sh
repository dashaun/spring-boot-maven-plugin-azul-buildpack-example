#!/usr/bin/env bash
. demo-magic.sh
export TYPE_SPEED=100
export DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"
TEMP_DIR=upgrade-example

function talkingPoint() {
  wait
  clear
}

function initSDK() {
  source "$HOME/.sdkman/bin/sdkman-init.sh"
}

function createAppWithInitializr {
  # hide the evidence
  rm -rf $TEMP_DIR
  mkdir $TEMP_DIR
  cd $TEMP_DIR || exit
  clear
  pei "sdk use java 17.0.7-zulu"
  pei "java -version"
  pei "curl https://start.spring.io/starter.tgz -d dependencies=web,actuator -d javaVersion=17 -d bootVersion=3.1.1 -d type=maven-project | tar -xzf - || exit"
}

function zuluBuilder {
  git init && git add . && git commit -m 'initializr'
  pei "initializr-plusplus extensions"
  pei "initializr-plusplus project-version"
  git add . && git commit -m 'extensions and project-version'
  clear
  pei "initializr-plusplus zulu-builder"
  pei "git --no-pager diff pom.xml"
  git add . && git commit -m 'zulu-builder'
}

function springBootBuildImage {
  pei "./mvnw spring-boot:build-image -DskipTests"
}

function validateImage {
  pei "docker run --name zuluImageExample --rm -d -p 8080:8080 demo:0.0.0"
  pei "docker stats --no-stream zuluImageExample"
  PROMPT_TIMEOUT=4
  wait
  PROMPT_TIMEOUT=0
  pei "http :8080/actuator/health"
  pei "docker exec zuluImageExample ls -latr"
  pei "docker exec zuluImageExample cat gc.log"
}

function cleanupImage {
  docker stop zuluImageExample
  docker rmi demo:0.0.0
  clear
}

initSDK
createAppWithInitializr
talkingPoint
zuluBuilder
talkingPoint
springBootBuildImage
talkingPoint
validateImage
talkingPoint
cleanupImage