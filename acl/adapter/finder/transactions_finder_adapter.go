package finder

import (
	"gringotts-api/acl/adapter/repository"
	"gringotts-api/domain"
	"log"
	"sync"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// implement domain.TransactionsFinder
type TransactionsFinderAdapter struct {
	dbContext *repository.DBContext
	collTran  *mongo.Collection
}

func NewTransactionsFinderAdapter() TransactionsFinderAdapter {
	ctx := repository.DBContext{}.GetInstance()
	return TransactionsFinderAdapter{
		dbContext: ctx,
		collTran:  ctx.Database.Collection("transactions"),
	}
}

func (finder TransactionsFinderAdapter) getByFilter(filter bson.M, pageNo, pageSize int) ([]domain.Transaction, error) {
	opts := options.Find().SetSort(bson.D{{Key: "traded_time", Value: -1}, {Key: "created_time", Value: -1}})
	opts.SetSkip(int64((pageNo - 1) * pageSize))
	opts.SetLimit(int64(pageSize))
	cursor, err := finder.collTran.Find(finder.dbContext.Context, filter, opts)
	if err != nil {
		return []domain.Transaction{}, err
	}

	models := []repository.TransactionModel{}
	if err = cursor.All(finder.dbContext.Context, &models); err != nil {
		return []domain.Transaction{}, err
	}

	trans := []domain.Transaction{}
	for _, mod := range models {
		trans = append(trans, mod.ConvertToTransaction())
	}

	return trans, err
}

func (finder TransactionsFinderAdapter) getTotalByFilter(filter bson.M) int {
	count, err := finder.collTran.CountDocuments(finder.dbContext.Context, filter)
	if err != nil {
		log.Printf("get transactions total faild, error: %s \n", err.Error())

		return 0
	}

	return int(count)
}

func (finder TransactionsFinderAdapter) getTransactionsByFilter(filter bson.M, pageNo, pageSize int) ([]domain.Transaction, int, error) {
	total := 0

	var wg sync.WaitGroup
	wg.Add(1)
	go func(wg *sync.WaitGroup) {
		defer wg.Done()

		total = finder.getTotalByFilter(filter)
	}(&wg)

	trans, err := finder.getByFilter(filter, pageNo, pageSize)
	if err != nil {
		return []domain.Transaction{}, 0, err
	}

	wg.Wait()

	return trans, total, nil
}

func (finder TransactionsFinderAdapter) FindAll(pageNo, pageSize int) ([]domain.Transaction, int, error) {
	return finder.getTransactionsByFilter(bson.M{}, pageNo, pageSize)
}

func (finder TransactionsFinderAdapter) FindByTags(tags []string, pageNo, pageSize int) ([]domain.Transaction, int, error) {
	filter := bson.M{}
	if len(tags) > 0 {
		regexTags := bson.A{}
		for _, tag := range tags {
			regexTags = append(regexTags, primitive.Regex{Pattern: tag})
		}
		filter["tags"] = bson.M{
			"$in": regexTags,
		}
	}

	return finder.getTransactionsByFilter(filter, pageNo, pageSize)
}

func (finder TransactionsFinderAdapter) FindByPeriod(start, end time.Time, pageNo, pageSize int) ([]domain.Transaction, int, error) {
	filter := bson.M{
		"$and": bson.A{
			bson.M{"traded_time": bson.M{"$gte": primitive.NewDateTimeFromTime(start)}},
			bson.M{"traded_time": bson.M{"$lt": primitive.NewDateTimeFromTime(end)}},
		},
	}

	return finder.getTransactionsByFilter(filter, pageNo, pageSize)
}

func (finder TransactionsFinderAdapter) Get(id string) (domain.Transaction, error) {
	filter := bson.M{"id": id}

	var model repository.TransactionModel
	if err := finder.collTran.FindOne(finder.dbContext.Context, filter).Decode(&model); err != nil {
		return domain.Transaction{}, err
	}

	return model.ConvertToTransaction(), nil
}
