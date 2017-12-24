build:
	protoc -I. --go_out=plugins=micro:. \
		proto/user/user.proto
	docker build -t user-service .

run:
	docker run -p 50053:50051 -e MICRO_SERVER_ADDRESS=:50051 -e MICRO_REGISTRY=mdns user-service
