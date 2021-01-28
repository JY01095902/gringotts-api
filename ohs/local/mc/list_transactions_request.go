package mc

import (
	"errors"
	"fmt"
	"strconv"
	"strings"
	"time"
)

type ListTransactionsRequest struct {
	Start    string `json:"year"`
	End      string `json:"month"`
	Tags     string `json:"tags"`
	PageNo   string `json:"page_no"`
	PageSize string `json:"page_size"`
}

func (req ListTransactionsRequest) ValidatePeriod() error {
	_, _, err := req.GetPeriod()
	if err != nil {
		return err
	}

	return nil
}

func (req ListTransactionsRequest) ValidatePageInfo() error {
	pageNo, err := strconv.Atoi(req.PageNo)
	if err != nil {
		return fmt.Errorf("page no is invalid, error: %s", err.Error())
	}

	if pageNo < 1 {
		return errors.New("page no should be greater than 0")
	}

	pageSize, err := strconv.Atoi(req.PageSize)
	if err != nil {
		return fmt.Errorf("page size is invalid, error: %s", err.Error())
	}

	if pageSize < 1 {
		return errors.New("page size should be greater than 0")
	}

	return nil
}

func (req ListTransactionsRequest) GetPageNo() int {
	pageNo, err := strconv.Atoi(req.PageNo)
	if err != nil {
		return 1
	}

	return pageNo
}

func (req ListTransactionsRequest) GetPageSize() int {
	pageSize, err := strconv.Atoi(req.PageSize)
	if err != nil {
		return 10
	}

	return pageSize
}

func (req ListTransactionsRequest) GetTags() []string {
	if req.Tags == "" {
		return []string{}
	}

	return strings.Split(req.Tags, ",")
}

func (req ListTransactionsRequest) GetPeriod() (time.Time, time.Time, error) {
	zero, _ := time.Parse(time.RFC3339, "0001-01-01T00:00:00Z")
	start, err := time.Parse(time.RFC3339, req.Start)
	if err != nil {
		return zero, zero, fmt.Errorf("start is invalid, error: %s", err.Error())
	}

	end, err := time.Parse(time.RFC3339, req.End)
	if err != nil {
		return zero, zero, fmt.Errorf("end is invalid, error: %s", err.Error())
	}

	return start, end, nil
}

func (req ListTransactionsRequest) IsByTags() bool {
	return req.Tags != ""
}

func (req ListTransactionsRequest) IsByPeriod() bool {
	_, _, err := req.GetPeriod()
	if err != nil {
		return false
	}

	return true
}
