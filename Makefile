.PHONY: clean down perms rmq-perms run start

NAME ?= rabbitmq-server-7253

clean: down perms
	docker container rm $(NAME)
	rm -rf $(CURDIR)/rabbitmq/mnesia
	rm -f $(CURDIR)/rabbitmq/.erlang.cookie

down:
	docker stop $(NAME)

perms:
	sudo chown -R "$(USER):$(USER)" $(CURDIR)

rmq-perms:
	sudo chown -R "999:999" $(CURDIR)/rabbitmq

start: rmq-perms
	docker start $(NAME)

run: rmq-perms
	docker run --name $(NAME) --mount type=bind,source="$(CURDIR)/rabbitmq",target=/var/lib/rabbitmq rabbitmq:latest
