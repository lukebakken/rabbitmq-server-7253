.PHONY: clean down fresh perms rmq-perms up

NAME ?= rabbitmq-server-7253

clean: down perms
	docker container rm $(NAME)
	rm -rf $(CURDIR)/rabbitmq/mnesia
	rm -f $(CURDIR)/rabbitmq/.erlang.cookie

down:
	docker stop $(NAME)

fresh: down clean up

perms:
	sudo chown -R "$(USER):$(USER)" $(CURDIR)

rmq-perms:
	sudo chown -R "999:999" $(CURDIR)/rabbitmq

up: rmq-perms
	docker run --name $(NAME) --mount type=bind,source="$(CURDIR)/rabbitmq",target=/var/lib/rabbitmq rabbitmq:latest
