IMAGE=mkadiri/golang-tester
TAG=latest

build:
	docker build -t ${IMAGE}:${TAG} .

run:
	docker run