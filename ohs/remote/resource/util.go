package resource

import (
	"gringotts-api/util"

	"github.com/kataras/iris/v12"
)

func setErrResult(ctx *iris.Context, err error) {
	logger := util.GetLoggerInstance()
	logger.Errorw("api response error", "error", err.Error())

	(*ctx).StatusCode(iris.StatusBadRequest)
	(*ctx).JSON(iris.Map{
		"data": iris.Map{
			"error": err.Error(),
		},
	})
}
