package domain

import (
	"fmt"
	"math/rand"
	"time"
)

type Transaction struct {
	Id           string
	Amount       float64
	CurrencyType string
	TradedTime   time.Time
	tags         []string
}

func NewTransaction() (Transaction, error) {
	randNum := fmt.Sprintf("%d", rand.New(rand.NewSource(time.Now().UnixNano())).Int31n(99999))
	id := fmt.Sprintf("T%s%s", time.Now().Format("060102150405"), randNum)

	tran := Transaction{
		Id:           id,
		CurrencyType: "CNY",
		TradedTime:   time.Now(),
		tags:         []string{},
	}

	return tran, nil
}

func (tran Transaction) GetTags() []string {
	return tran.tags
}

func (tran *Transaction) AddTags(tags []string) {
	if tran.tags == nil {
		tran.tags = []string{}
	}

	tran.tags = append(tran.tags, tags...)
}

func (tran *Transaction) RemoveTags(tags []string) {
	newTags := []string{}
	tagsMap := map[string]struct{}{}
	for _, tag := range tags {
		tagsMap[tag] = struct{}{}
	}

	for _, tag := range tran.tags {
		if _, exist := tagsMap[tag]; !exist {
			newTags = append(newTags, tag)
		}
	}

	tran.tags = newTags
}

func (tran *Transaction) ClearTags() {
	tran.tags = []string{}
}
