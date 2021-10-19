package main

import (
	"bufio"
	"context"
	"fmt"
	"github.com/go-redis/redis/v8"
	"os"
	"time"
)

const channelName string = "chat"

func main() {
	rdb := redis.NewClient(&redis.Options{
		Addr:     "10.10.0.180:33333",
		Password: "",
		DB:       0,
	})

	pubsub := rdb.Subscribe(context.TODO(), channelName)
	defer pubsub.Close()

	go listen(pubsub)

	for {
		reader := bufio.NewReader(os.Stdin)
		text, _ := reader.ReadString('\n')
		_, err := rdb.Publish(context.TODO(), channelName, text).Result()
		if err != nil {
			return
		}
	}

}

func listen(pubsub *redis.PubSub) {
	for {
		msgi, err := pubsub.Receive(context.Background())
		if err != nil {
			break
		}
		switch msg := msgi.(type) {
		case *redis.Message:
			fmt.Printf("[MESSAGE][%v]@%v: %v ", time.Now().Unix(), msg.Channel, msg.Payload)
		}
	}
}
