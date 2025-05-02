package main

import (
	"log"
	"time"
)

func main() {
	log.Println("Starting monitors service...")

	for {
		log.Println("Time check:", time.Now().Format(time.RFC3339))
		time.Sleep(10 * time.Second)
	}
}


