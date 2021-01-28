package application

import (
	"gringotts-api/acl/adapter/finder"
	"gringotts-api/acl/port"
)

type TagAppService struct {
	tagsFinder port.TagsFinder
}

func NewTagAppService() TagAppService {
	return TagAppService{
		tagsFinder: finder.NewTagsFinderAdapter(),
	}
}

func (app TagAppService) ListAllTags() ([]string, error) {
	return app.tagsFinder.FindAll()
}
