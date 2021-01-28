package mc

import (
	"errors"
	"fmt"
	"strconv"
	"time"
)

type PatchTransactionRequest struct {
	Id         string   `json:"id"`
	Amount     float64  `json:"amount"`
	TradedTime string   `json:"traded_time"`
	Tags       []string `json:"tags"`
}

func (req PatchTransactionRequest) Validate() error {
	if req.Id == "" {
		return errors.New("id is required")
	}

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

func (req PatchTransactionRequest) GetTradedTime() (time.Time, error) {
	return time.Parse(time.RFC3339, req.TradedTime)
}

// 四舍五入保留二位小数
func (req PatchTransactionRequest) GetAmount() (float64, error) {
	amt, err := strconv.ParseFloat(fmt.Sprintf("%.2f", req.Amount), 64)
	if err != nil {
		return 0, err
	}

	return amt, nil
}
