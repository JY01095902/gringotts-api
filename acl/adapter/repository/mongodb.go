package repository

import (
	"context"
	"fmt"
	"os"
	"sync"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var dbContext *DBContext
var dbContextOnce sync.Once

type DBContext struct {
	Context        context.Context
	Database       *mongo.Database
	CancelFunction context.CancelFunc
}

func (DBContext) GetInstance() *DBContext {
	dbContextOnce.Do(func() {
		serverURI := fmt.Sprintf("mongodb://%v:%v@%v:%v", os.Getenv("GRINGOTTS_MONGO_USERNAME"), os.Getenv("GRINGOTTS_MONGO_PASSWORD"), os.Getenv("GRINGOTTS_MONGO_IP"), os.Getenv("GRINGOTTS_MONGO_PORT"))
		dbName := os.Getenv("GRINGOTTS_MONGO_DB_NAME")

		ctx, cancelFunc := context.WithCancel(context.Background())
		client, err := mongo.Connect(ctx, options.Client().ApplyURI(serverURI))
		if err != nil {
			errMsg := fmt.Sprintf("create mongodb client failed, error: %v", err.Error())
			panic(errMsg)
		}

		dbContext = &DBContext{
			Context:        ctx,
			Database:       client.Database(dbName),
			CancelFunction: cancelFunc,
		}
	})

	return dbContext
}
