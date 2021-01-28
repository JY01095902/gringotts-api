package main

import (
	"gringotts-api/ohs/remote/resource"
	"runtime"
	_ "time/tzdata"

	"github.com/iris-contrib/middleware/cors"
	"github.com/kataras/iris/v12"
	"github.com/kataras/iris/v12/middleware/logger"
	irisRecover "github.com/kataras/iris/v12/middleware/recover"
)

func main() {
	runAPI()
}

func runAPI() {
	app := iris.New()
	app.Logger().SetLevel("debug")
	app.Use(irisRecover.New())
	app.Use(logger.New())
	crs := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowCredentials: true,
		AllowedMethods: []string{
			iris.MethodOptions,
			iris.MethodGet,
			iris.MethodPost,
			iris.MethodDelete,
			iris.MethodPut,
			iris.MethodPatch,
		},
	})

	v1 := app.Party("/api/v1", crs).AllowMethods(iris.MethodOptions)
	{
		v1.Get("/ping", func(ctx iris.Context) {
			ctx.WriteString("pong")
		})

		v1.Get("/tags", resource.ListTags)

		v1.Post("/transactions", resource.CreateTransaction)

		v1.Get("/transactions", resource.ListTransactions)

		v1.Get("/transactions/{id}", resource.GetTransaction)

		v1.Patch("/transactions/{id}", resource.PatchTransaction)

		v1.Delete("/transactions/{id}", resource.DeleteTransaction)
	}

	runtime.GOMAXPROCS(runtime.NumCPU())

	app.Run(iris.Addr(":9297"))
}
