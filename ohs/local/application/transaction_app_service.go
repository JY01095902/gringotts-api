package application

import (
	"gringotts-api/acl/adapter/finder"
	"gringotts-api/acl/adapter/repository"
	"gringotts-api/acl/port"
	"gringotts-api/domain"
	"gringotts-api/ohs/local/mc"
	"log"
	"time"
)

type TransactionAppService struct {
	tranRepo    port.TransactionRepository
	transFinder port.TransactionsFinder
}

func NewTransactionAppService() TransactionAppService {
	return TransactionAppService{
		tranRepo:    repository.NewTransactionRepositoryAdapter(),
		transFinder: finder.NewTransactionsFinderAdapter(),
	}
}

func (app TransactionAppService) CreateTransaction(req mc.CreateTransactionRequest) (domain.Transaction, error) {
	tran, err := domain.NewTransaction()
	if err != nil {
		log.Printf("create transaction faild, error: %s\n", err.Error())

		return domain.Transaction{}, err
	}
	tran.AddTags(req.Tags)
	tran.CurrencyType = req.CurrencyType

	tradedTime, err := req.GetTradedTime()
	if err != nil {
		return domain.Transaction{}, err
	}
	tran.TradedTime = tradedTime

	amt, err := req.GetAmount()
	if err != nil {
		return domain.Transaction{}, err
	}
	tran.Amount = amt

	err = app.tranRepo.Save(tran)
	if err != nil {
		return domain.Transaction{}, err
	}
	log.Printf("tran.Id: %s\n", tran.Id)

	return app.transFinder.Get(tran.Id)
}

func (app TransactionAppService) ListAllTransactions(pageNo, pageSize int) ([]domain.Transaction, int, error) {
	return app.transFinder.FindAll(pageNo, pageSize)
}

func (app TransactionAppService) ListTransactionsByPeriod(start, end time.Time, pageNo, pageSize int) ([]domain.Transaction, int, error) {
	trans, total, err := app.transFinder.FindByPeriod(start, end, pageNo, pageSize)
	if err != nil {
		return []domain.Transaction{}, 0, err
	}

	return trans, total, nil
}

func (app TransactionAppService) ListTransactionsByTags(tags []string, pageNo, pageSize int) ([]domain.Transaction, int, error) {
	trans, total, err := app.transFinder.FindByTags(tags, pageNo, pageSize)
	if err != nil {
		return []domain.Transaction{}, 0, err
	}

	return trans, total, nil
}

func (app TransactionAppService) GetTransaction(id string) (domain.Transaction, error) {
	return app.transFinder.Get(id)
}

func (app TransactionAppService) PatchTransaction(req mc.PatchTransactionRequest) error {
	tran, err := app.tranRepo.Get(req.Id)
	if err != nil {
		return err
	}

	amt, err := req.GetAmount()
	if err != nil {
		return err
	}

	tradedTime, err := req.GetTradedTime()
	if err != nil {
		return err
	}

	tran.Amount = amt
	tran.TradedTime = tradedTime
	tran.ClearTags()
	tran.AddTags(req.Tags)

	return app.tranRepo.Save(tran)
}

func (app TransactionAppService) DeleteTransaction(id string) error {
	tran, err := app.tranRepo.Get(id)
	if err != nil {
		return err
	}

	return app.tranRepo.Delete(tran)
}
