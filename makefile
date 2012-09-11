setup:
	npm install

test:
	NODE_ENV='test' node_modules/.bin/mocha --compilers coffee:coffee-script -R list -t 30000 test/*.test.coffee

publish: test
	git push github master
	npm prune
	npm publish

link:
	sudo npm link

.PHONY: setup test publish link
