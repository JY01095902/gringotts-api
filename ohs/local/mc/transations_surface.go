// mc: message contract
package mc

import (
	"gringotts-api/domain"
	"time"
)

type TransactionSurface struct {
	Id           string   `json:"id"`
	Amount       float64  `json:"amount"`
	CurrencyType string   `json:"currency_type"`
	TradedTime   string   `json:"traded_time"`
	Tags         []string `json:"tags"`
}

func NewTransactionSurface(tran domain.Transaction) TransactionSurface {
	sf := TransactionSurface{
		Id:           tran.Id,
		Amount:       tran.Amount,
		CurrencyType: tran.CurrencyType,
		TradedTime:   tran.TradedTime.Format(time.RFC3339),
		Tags:         tran.GetTags(),
	}

	return sf
}

type TransactionsSurface struct {
	Items      []TransactionSurface `json:"items"`
	TotalItems int                  `json:"total_items"`
	PageNo     int                  `json:"page_no"`
	PageSize   int                  `json:"page_size"`
}

func NewTransactionsSurface(trans []domain.Transaction, pageNo, pageSize, total int) TransactionsSurface {
	tranSurfaceList := make([]TransactionSurface, len(trans))
	for i, tran := range trans {
		tranSurfaceList[i] = NewTransactionSurface(tran)
	}

	sf := TransactionsSurface{}
	sf.Items = tranSurfaceList
	sf.TotalItems = total
	sf.PageNo = pageNo
	sf.PageSize = pageSize

	return sf
}
