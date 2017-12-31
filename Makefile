build:
	# This builds out our go-micro generated code, but imports
	# grpc-gateway so the new metadata can be understood.
	protoc -I. \
		-I$(GOPATH)/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
		--go_out=plugins=micro:. \
		proto/user/user.proto

	# This builds out the auto-generated API code, into a directory called 'api'.
	protoc -I/usr/local/include -I. \
		-I$(GOPATH)/src \
	  -I$(GOPATH)/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
	  --grpc-gateway_out=logtostderr=true:$(GOPATH)/src/github.com/EwanValentine/shippy-user-service/api \
	  proto/user/user.proto

	# This builds out a non go-micro gRPC layer. We need to generate this as well
	# as the go-micro code as grpc-gateway code doesn't play nicely with the go-micro code.
	# This had me confused for a long-time, so don't feel bad if your head is spinning at this point...
	protoc -I/usr/local/include -I. \
	  -I$(GOPATH)/src \
	  -I$(GOPATH)/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
	  --go_out=plugins=grpc:$(GOPATH)/src/github.com/EwanValentine/shippy-user-service/api \
	  proto/user/user.proto

	# This generates swagger files, totally optional, but nice for a REST api, right?
	protoc -I/usr/local/include -I. \
	  -I$(GOPATH)/src \
	  -I$(GOPATH)/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
	  --swagger_out=logtostderr=true:$(GOPATH)/src/github.com/EwanValentine/shippy-user-service/api \
		proto/user/user.proto

	docker build -t shippy-user-service .

run:
	docker run -d --net="host" \
		-p 50051 \
		-e DB_HOST=localhost \
		-e DB_PASS=password \
		-e DB_USER=postgres \
		-e MICRO_SERVER_ADDRESS=:50051 \
		-e MICRO_REGISTRY=mdns \
		shippy-user-service
