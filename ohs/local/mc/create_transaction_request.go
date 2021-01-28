package mc

import (
	"fmt"
	"strconv"
	"time"
)

type CreateTransactionRequest struct {
	Amount       float64  `json:"amount"`
	CurrencyType string   `json:"currency_type"`
	TradedTime   string   `json:"traded_time"`
	Tags         []string `json:"tags"`
}

func (req CreateTransactionRequest) Validate() error {
	_, err := req.GetAmount()
	if err != nil {
		return err
	}

	_, err = req.GetTradedTime()
	if err != nil {
		return err
	}

	return nil
}

func (req CreateTransactionRequest) GetTradedTime() (time.Time, error) {
	return time.Parse(time.RFC3339, req.TradedTime)
}

// 四舍五入保留二位小数
func (req CreateTransactionRequest) GetAmount() (float64, error) {
	amt, err := strconv.ParseFloat(fmt.Sprintf("%.2f", req.Amount), 64)
	if err != nil {
		return 0, err
	}

	return amt, nil
}
