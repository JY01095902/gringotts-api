package port

import (
	"gringotts-api/domain"
)

type TransactionRepository interface {
	Get(id string) (domain.Transaction, error)
	Save(tran domain.Transaction) error
	Delete(tran domain.Transaction) error
}
