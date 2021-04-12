package main

import (
	"fmt"
	"log"
	"math/rand"
	"net"
	"sync"
	"time"

	pb "github.com/ednofedulo/test-go/data"

	"google.golang.org/grpc"
)

type server struct {
	pb.UnimplementedStreamServiceServer
}

type boolgen struct {
	src       rand.Source
	cache     int64
	remaining int
}

func (b *boolgen) Bool() bool {
	if b.remaining == 0 {
		b.cache, b.remaining = b.src.Int63(), 63
	}

	result := b.cache&0x01 == 1
	b.cache >>= 1
	b.remaining--

	return result
}

func New() *boolgen {
	return &boolgen{src: rand.NewSource(time.Now().UnixNano())}
}

func (s server) FetchResponse(in *pb.Request, srv pb.StreamService_FetchResponseServer) error {

	log.Printf("fetch response for id : %d", in.Id)
	r := New()
	var value = 500
	var count = 1
	var wg sync.WaitGroup

	for {
		if r.Bool() {
			value = value + 1
		} else {
			value = value - 1
		}

		wg.Add(1)
		go func(value int, count int) {
			defer wg.Done()

			time.Sleep(time.Duration(count) * time.Second)
			resp := pb.Response{Result: fmt.Sprintf("%d", value)}
			if err := srv.Send(&resp); err != nil {
				log.Printf("send error %v", err)
			}
		}(value, count)
		count = count + 1
	}

	wg.Wait()
	return nil
}

func main() {

	lis, err := net.Listen("tcp", ":50005")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	pb.RegisterStreamServiceServer(s, server{})

	log.Println("start server")

	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}

}
