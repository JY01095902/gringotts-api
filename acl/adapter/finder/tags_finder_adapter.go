package finder

import (
	"gringotts-api/acl/adapter/repository"
	"gringotts-api/util"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type TagsFinderAdapter struct {
	dbContext *repository.DBContext
	collBFile *mongo.Collection
	logger    util.Logger
}

func NewTagsFinderAdapter() TagsFinderAdapter {
	ctx := repository.DBContext{}.GetInstance()
	return TagsFinderAdapter{
		dbContext: ctx,
		collBFile: ctx.Database.Collection("transactions"),
		logger:    util.GetLoggerInstance(),
	}
}

func (finder TagsFinderAdapter) FindAll() ([]string, error) {
	pipe := []bson.M{
		bson.M{"$project": bson.M{"tags": 1}},
		bson.M{"$unwind": "$tags"},
		bson.M{"$group": bson.M{
			"_id": "$tags",
		}},
		bson.M{"$addFields": bson.M{"tag": "$_id"}},
	}
	opts := options.Aggregate().SetMaxTime(2 * time.Second)
	cursor, err := finder.collBFile.Aggregate(finder.dbContext.Context, pipe, opts)
	if err != nil {
		return []string{}, err
	}

	var results []bson.M
	if err = cursor.All(finder.dbContext.Context, &results); err != nil {
		return []string{}, err
	}

	finder.logger.Debugw("get all tags", "results", results)

	tags := []string{}
	for _, result := range results {
		if tag, ok := result["tag"].(string); ok {
			tags = append(tags, tag)
		}
	}

	return tags, nil
}
