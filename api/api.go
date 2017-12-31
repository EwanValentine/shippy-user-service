package api

import (
	"net/http"

	api "github.com/EwanValentine/shippy-user-service/api/proto/user"
	"github.com/grpc-ecosystem/grpc-gateway/runtime"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

// Init a rest API
func Init() error {
	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	// New server multiplexer
	mux := runtime.NewServeMux()
	opts := []grpc.DialOption{grpc.WithInsecure()}

	// Our gRPC host address
	conn := "localhost:50051"

	// Register the handler to an endpoint
	err := api.RegisterUserServiceHandlerFromEndpoint(ctx, mux, conn, opts)
	if err != nil {
		return err
	}

	// Return a server instance
	return http.ListenAndServe(":8080", mux)
}
