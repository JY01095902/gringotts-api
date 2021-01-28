package repository

import (
	"gringotts-api/domain"
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type TransactionModel struct {
	Id           string             `bson:"id"`
	Amount       float64            `bson:"amount"`
	CurrencyType string             `bson:"currency_type"`
	TradedTime   time.Time          `bson:"traded_time"`
	Tags         []string           `bson:"tags"`
	CreatedTime  primitive.DateTime `bson:"created_time,omitempty"`
	ModifiedTime primitive.DateTime `bson:"modified_time,omitempty"`
}

func (model TransactionModel) ConvertToTransaction() domain.Transaction {
	tran := domain.Transaction{
		Id:           model.Id,
		Amount:       model.Amount,
		CurrencyType: model.CurrencyType,
		TradedTime:   model.TradedTime,
	}
	tran.AddTags(model.Tags)

	return tran
}

func createTransactionModel(tran domain.Transaction) TransactionModel {
	return TransactionModel{
		Id:           tran.Id,
		Amount:       tran.Amount,
		CurrencyType: tran.CurrencyType,
		TradedTime:   tran.TradedTime,
		Tags:         tran.GetTags(),
	}
}
