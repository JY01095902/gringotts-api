package port

import (
	"gringotts-api/domain"
	"time"
)

type TransactionsFinder interface {
	FindAll(pageNo, pageSize int) ([]domain.Transaction, int, error)
	FindByTags(tags []string, pageNo, pageSize int) ([]domain.Transaction, int, error)
	FindByPeriod(start, end time.Time, pageNo, pageSize int) ([]domain.Transaction, int, error)
	Get(id string) (domain.Transaction, error)
}

type TagsFinder interface {
	FindAll() ([]string, error)
}
