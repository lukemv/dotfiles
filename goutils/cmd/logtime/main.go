package main

import (
	"log"
	"time"
)

func main() {
	log.Println("Starting logtime service...")

	for {
		log.Println("Time check:", time.Now().Format(time.RFC3339))
		time.Sleep(60 * time.Second)
	}
}

