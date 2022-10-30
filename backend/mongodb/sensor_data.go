package mongodb

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Sensor_Metadata struct {
	DeviceId   string `json:"device_id,omitempty" bson:"device_id,omitempty"`
	SensorType string `bson:"type" json:"sensor_type"`
}

type Sensor_data struct {
	// id        string    `bson:"_id"`
	Value     float64            `bson:"value" json:"value"`
	Timestamp primitive.DateTime `bson:"timestamp" json:"timestamp"`
	Metadata  Sensor_Metadata    `bson:"metadata" json:"metadata"`
}

type Post_data struct {
	Value          float64            `bson:"value" json:"value"`
	Timestamp      primitive.DateTime `bson:"timestamp" json:"timestamp"`
	SensorMetadata Sensor_Metadata    `bson:"metadata" json:"metadata"`
}
