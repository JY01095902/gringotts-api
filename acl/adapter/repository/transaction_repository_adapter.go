package repository

import (
	"fmt"
	"gringotts-api/domain"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// implement domain.TransactionRepository
type TransactionRepositoryAdapter struct {
	dbContext *DBContext
	collTran  *mongo.Collection
}

func NewTransactionRepositoryAdapter() TransactionRepositoryAdapter {
	ctx := DBContext{}.GetInstance()
	return TransactionRepositoryAdapter{
		dbContext: ctx,
		collTran:  ctx.Database.Collection("transactions"),
	}
}

func (repo TransactionRepositoryAdapter) Save(tran domain.Transaction) error {
	_, err := repo.Get(tran.Id)
	if err != nil && err == mongo.ErrNoDocuments {
		return repo.insert(tran)
	}

	return repo.update(tran)
}

func (repo TransactionRepositoryAdapter) insert(tran domain.Transaction) error {
	model := createTransactionModel(tran)
	model.CreatedTime = primitive.NewDateTimeFromTime(time.Now())
	result, err := repo.collTran.InsertOne(repo.dbContext.Context, model)
	if err != nil {
		return fmt.Errorf("save transaction failed. error: %s", err.Error())
	}

	if result.InsertedID == nil {
		return fmt.Errorf("save transaction failed. data: %+v", model)
	}

	return nil
}

func (repo TransactionRepositoryAdapter) update(tran domain.Transaction) error {
	opts := options.Update().SetUpsert(false)
	filter := bson.M{
		"id": tran.Id,
	}
	model := createTransactionModel(tran)
	model.ModifiedTime = primitive.NewDateTimeFromTime(time.Now())
	update := bson.M{
		"$set": model,
	}
	_, err := repo.collTran.UpdateOne(repo.dbContext.Context, filter, update, opts)
	if err != nil {
		return fmt.Errorf("update transaction failed. error: %s", err.Error())
	}

	return nil
}

func (repo TransactionRepositoryAdapter) Get(id string) (domain.Transaction, error) {
	filter := bson.M{"id": id}
	var model TransactionModel
	if err := repo.collTran.FindOne(repo.dbContext.Context, filter).Decode(&model); err != nil {
		return domain.Transaction{}, err
	}

	tran := model.ConvertToTransaction()

	return tran, nil
}

func (repo TransactionRepositoryAdapter) Delete(tran domain.Transaction) error {
	filter := bson.M{"id": tran.Id}
	_, err := repo.collTran.DeleteOne(repo.dbContext.Context, filter)

	return err
}
