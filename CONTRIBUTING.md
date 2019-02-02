# HELP WANTED
I am happy about any help, no matter how small the contribution, whether code, examples or documentation. Simply create an issue or even better: contribute with a pull request!
Please _don't_ fork and maintain your own branch if you can avoid it. Rather do what you can to contribute to existing projects and keep them alive.

## create a pull request
* fork the repo
* do your changes in your repo, commit to your fork as often as you want
* when done, run test commands below to make sure that it builds
* create a pull request on github
  * give it a useful name, ideally describing the feature/change
  * describe in detail what has changed and if needed why

## size of contributions
* I prefer smaller and more frequent updates.
* Make a small change and do a pull request, don't build a huge update and wait weeks or months before doing a PR.

## TEST
* run travis lint
`docker run --rm -it -v $PWD:/project caktux/travis-cli lint .travis.yml`

* build the image
`docker build -t test .`

* run the image and dump a sample
`docker run --rm -it test telegraf --test`
