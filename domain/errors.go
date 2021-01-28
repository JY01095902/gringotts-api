package domain

import "errors"

var (
	ErrListTagsFailed          = errors.New("list tags failed")
	ErrInvalidId               = errors.New("id is invalid")
	ErrCreateTransactionFailed = errors.New("create transaction failed")
	ErrListTransactionsFailed  = errors.New("list transactions failed")
	ErrGetTransactionFailed    = errors.New("get transaction failed")
	ErrUpdateTransactionFailed = errors.New("update transaction failed")
	ErrDeleteTransactionFailed = errors.New("delete transaction failed")
)
