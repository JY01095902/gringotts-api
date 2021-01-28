package resource

import (
	"fmt"
	"gringotts-api/domain"
	"gringotts-api/ohs/local/application"

	"github.com/kataras/iris/v12"
)

func ListTags(ctx iris.Context) {
	app := application.NewTagAppService()
	tags, err := app.ListAllTags()
	if err != nil {
		setErrResult(&ctx, fmt.Errorf("%w, error: %s", domain.ErrListTagsFailed, err.Error()))

		return
	}

	ctx.StatusCode(iris.StatusOK)
	ctx.JSON(iris.Map{
		"data": tags,
	})
}
