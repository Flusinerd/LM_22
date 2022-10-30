package main

import (
	"backend/mongodb"
	"context"
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}

	uri := os.Getenv("MONGODB_URI")
	if uri == "" {
		log.Fatal("You must set your 'MONGODB_URI' environmental variable. See\n\t https://www.mongodb.com/docs/drivers/go/current/usage-examples/#environment-variable")
	}

	client, err := mongo.Connect(context.TODO(), options.Client().ApplyURI(uri))
	if err != nil {
		panic(err)
	}

	defer func() {
		if err := client.Disconnect(context.TODO()); err != nil {
			panic(err)
		}
	}()

	coll := client.Database("lm").Collection("sensor_data")

	r := gin.Default()
	r.GET("/data", func(c *gin.Context) {
		var results []mongodb.Sensor_data
		cursor, err := coll.Find(context.TODO(), bson.D{})
		if err != nil {
			log.Fatal(err)
		}
		if err := cursor.All(context.TODO(), &results); err != nil {
			log.Fatal(err)
		}

		// Marshal the slice of results into a JSON string

		c.JSON(http.StatusOK, results)
	})

	r.POST("/data", func(c *gin.Context) {
		var data []mongodb.Post_data
		if err := c.ShouldBindJSON(&data); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		newValue := make([]interface{}, len(data))
		for i, v := range data {
			newValue[i] = v
		}

		if _, err := coll.InsertMany(context.TODO(), newValue); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusCreated, gin.H{"status": "created"})
	})
	r.Run()
}
