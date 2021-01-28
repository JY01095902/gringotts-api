package resource

import (
	"gringotts-api/domain"
	"gringotts-api/ohs/local/application"
	"gringotts-api/ohs/local/mc"

	"fmt"

	"github.com/kataras/iris/v12"
)

func CreateTransaction(ctx iris.Context) {
	var req mc.CreateTransactionRequest
	if err := ctx.ReadJSON(&req); err != nil {
		setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrCreateTransactionFailed, err.Error()))

		return
	}

	if err := req.Validate(); err != nil {
		setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrCreateTransactionFailed, err.Error()))

		return
	}

	tran, err := application.NewTransactionAppService().CreateTransaction(req)
	if err != nil {
		setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrCreateTransactionFailed, err.Error()))

		return
	}

	ctx.StatusCode(iris.StatusCreated)
	ctx.JSON(iris.Map{
		"data": mc.NewTransactionSurface(tran),
	})
}

func ListTransactions(ctx iris.Context) {
	req := mc.ListTransactionsRequest{
		Start:    ctx.URLParam("start"),
		End:      ctx.URLParam("end"),
		Tags:     ctx.URLParam("tags"),
		PageNo:   ctx.URLParam("page_no"),
		PageSize: ctx.URLParam("page_size"),
	}

	if err := req.ValidatePageInfo(); err != nil {
		setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrListTransactionsFailed, err.Error()))

		return
	}

	pageNo, pageSize := req.GetPageNo(), req.GetPageSize()

	if req.IsByTags() {
		app := application.NewTransactionAppService()
		trans, total, err := app.ListTransactionsByTags(req.GetTags(), pageNo, pageSize)
		if err != nil {
			setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrListTransactionsFailed, err.Error()))

			return
		}

		result := iris.Map{
			"data": mc.NewTransactionsSurface(trans, pageNo, pageSize, total),
		}

		ctx.StatusCode(iris.StatusOK)
		ctx.JSON(result)

		return
	}

	if req.IsByPeriod() {
		if err := req.ValidatePeriod(); err != nil {
			setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrListTransactionsFailed, err.Error()))

			return
		}

		app := application.NewTransactionAppService()
		start, end, err := req.GetPeriod()
		if err != nil {
			setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrListTransactionsFailed, err.Error()))

			return
		}

		trans, total, err := app.ListTransactionsByPeriod(start, end, pageNo, pageSize)
		if err != nil {
			setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrListTransactionsFailed, err.Error()))

			return
		}

		result := iris.Map{
			"data": mc.NewTransactionsSurface(trans, pageNo, pageSize, total),
		}

		ctx.StatusCode(iris.StatusOK)
		ctx.JSON(result)

		return
	}

	app := application.NewTransactionAppService()
	trans, total, err := app.ListAllTransactions(pageNo, pageSize)
	if err != nil {
		setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrListTransactionsFailed, err.Error()))

		return
	}

	result := iris.Map{
		"data": mc.NewTransactionsSurface(trans, pageNo, pageSize, total),
	}

	ctx.StatusCode(iris.StatusOK)
	ctx.JSON(result)
}

func GetTransaction(ctx iris.Context) {
	id := ctx.Params().Get("id")
	if id == "" {
		setErrResult(&ctx, fmt.Errorf("%w, error: id is required", domain.ErrGetTransactionFailed))

		return
	}

	app := application.NewTransactionAppService()
	tran, err := app.GetTransaction(id)
	if err != nil {
		setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrGetTransactionFailed, err.Error()))

		return
	}

	result := iris.Map{
		"data": mc.NewTransactionSurface(tran),
	}

	ctx.StatusCode(iris.StatusOK)
	ctx.JSON(result)
}

func PatchTransaction(ctx iris.Context) {
	var req mc.PatchTransactionRequest
	if err := ctx.ReadJSON(&req); err != nil {
		setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrUpdateTransactionFailed, err.Error()))

		return
	}
	req.Id = ctx.Params().Get("id")

	if err := req.Validate(); err != nil {
		setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrUpdateTransactionFailed, err.Error()))

		return
	}

	err := application.NewTransactionAppService().PatchTransaction(req)
	if err != nil {
		setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrUpdateTransactionFailed, err.Error()))

		return
	}

	ctx.StatusCode(iris.StatusNoContent)
}

func DeleteTransaction(ctx iris.Context) {
	id := ctx.Params().Get("id")

	err := application.NewTransactionAppService().DeleteTransaction(id)
	if err != nil {
		setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrDeleteTransactionFailed, err.Error()))

		return
	}

	ctx.StatusCode(iris.StatusNoContent)
}
