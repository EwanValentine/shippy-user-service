build:
	protoc -I/usr/local/include -I. \
		--go_out=plugins=micro:. \
		proto/auth/auth.proto
	docker build -t ewanvalentine/user:latest .
	docker push ewanvalentine/user:latest

run:
	docker run --net="host" \
		-p 50051 \
		-e DB_HOST=localhost \
		-e DB_PASS=password \
		-e DB_USER=postgres \
		-e MICRO_SERVER_ADDRESS=:50051 \
		-e MICRO_REGISTRY=mdns \
		shippy-user-service

deploy:
	sed "s/{{ UPDATED_AT }}/$(shell date)/g" ./deployments/deployment.tmpl > ./deployments/deployment.yml
	kubectl replace -f ./deployments/deployment.yml
